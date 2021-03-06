'use strict';

const { id } = require('date-fns/locale');
const { idChecker, tableNames, httpStatus, ResponseError } = require('../../../helpers');
const notificationServices = require('../../notification/services');
const publicationRepository = require('../../../repositories/publication.repository');
const typeNotifications = require('../../notification/helper/type.notification');
const visitRepository = require('../../../repositories/visit.repository');
const userServices = require('../../user/services');
const visitValidator = require('../validations');

const { HTTP_CLIENT_NAME } = process.env;

async function insertVisit({ visitDate, visitHour, idPublication }, idUser) {
  await visitValidator.validateInsertVisit({ visitDate, visitHour, idPublication });
  const haveVisit = await visitRepository.haveVisit(idUser, idPublication);
  if (!haveVisit) {
    const publication = await publicationRepository.existsPublication(idPublication);
    if (publication) {
      const visitId = await idChecker(tableNames.VISIT);
      const visit = {
        id: visitId,
        visit_date: visitDate,
        visit_hour: visitHour,
        id_publication: idPublication,
        id_user_visitant: idUser,
      };
      await notificationServices.newNotification({
        type: typeNotifications.VISIT,
        idUser,
      });
      const userEmail = await publicationRepository.findPublicationOwner(idPublication);

      await userServices.sendConfirmationEmail(
        userEmail,
        'YourPlace new request visit',
        '¡Somebody want to visit yourplace!',
        '¡Please anwser him as soon as posible!',
        `${HTTP_CLIENT_NAME}/profile`,
        '¡Go to my profile!'
      );
      return await visitRepository.insertVisit(visit);
    }
    throw new ResponseError(httpStatus.NOT_FOUND, 'PUBLICATION NOT FOUND');
  }
  throw new ResponseError(httpStatus.CONFLICT, 'YOU CANT ADD MORE VISITS TO THIS RESERVATION');
}

module.exports = insertVisit;
