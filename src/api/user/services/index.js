module.exports = {
  loginUser: require('./login.user.service'),
  registerUser: require('./register.user.service'),
  sendConfirmationEmail: require('./send.confirmation.email.user.service'),
  updateUser: require('./update.user.service'),
  verifyUser: require('./verify.user.service'),
  getUser: require('./get.user.service'),
  updateRating: require('./update.rating.user.service'),
  insertRating: require('./insert.rating.user.service'),
};
