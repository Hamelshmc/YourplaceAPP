import { joiResolver } from '@hookform/resolvers/joi';
import { useContext } from 'react';
import { useForm } from 'react-hook-form';
import { useMutation } from 'react-query';
import { Redirect, useParams } from 'react-router-dom';
import { toast } from 'react-toastify';
import styled from 'styled-components';
import { fetchAuthDataPost } from '../api/User';
import { fetchAddVisit } from '../api/Visit';
import bookingSchema from '../components/Booking/validations/bookingSchema';
import InputForm from '../components/shared/Form/InputForm';
import Form from '../components/shared/Form/styles/Form';
import FormContainer from '../components/shared/Form/styles/FormContainer';
import FormTitle from '../components/shared/Form/styles/FormTitle';
import SubmitButton from '../components/shared/Form/styles/SubmitButton';
import { UserContext } from '../hooks/UserContext';

const NewVisit = () => {
  const [user, setUser] = useContext(UserContext);
  const { id } = useParams();

  const mutation = useMutation(
    async (data) => await fetchAuthDataPost(fetchAddVisit, user, setUser, data),
    {
      onSuccess: (result) => {
        if (result.status === 201) {
          toast.success(`Visit added! 😄`);
        } else {
          toast.error(`🙈  ${result.data}  🙈 `);
        }
      },
    }
  );

  const { register, handleSubmit, errors } = useForm({
    resolver: joiResolver(bookingSchema),
    mode: 'onChange',
  });

  const onSubmit = async (data) => {
    try {
      const { startDate } = data;
      const date = new Date(startDate).toISOString().split('T')[0];
      await mutation.mutateAsync({ ...data, startDate: date, idPublication: id });
    } catch (error) {
      toast.error(`${error.message} 🙈 Ooops! Connection error 🙈 `);
    }
  };

  return (
    <BookingContainer>
      <FormContainer>
        <Form onSubmit={handleSubmit(onSubmit)}>
          <FormTitle>New visit</FormTitle>
          <InputForm
            id="visit_date"
            name="visit_date"
            label="Visit date"
            type="date"
            errorMsg={errors.visit_date && errors.visit_date.message}
            error={errors.visit_date}
            placeholder="2021-01-01"
            reference={register}
          />
          <InputForm
            id="visit_hour"
            name="visit_hour"
            label="visit_hour"
            type="time"
            errorMsg={errors.visit_hour && errors.visit_hour.message}
            error={errors.visit_hour}
            placeholder="10:00"
            reference={register}
          />
          <SubmitButton id="addVisit">
            {mutation.isLoading ? (
              'Doing interesting things...'
            ) : (
              <>
                {mutation.data && mutation.data.status >= 400 ? (
                  `Try again!`
                ) : mutation.isSuccess ? (
                  <Redirect to="/profile" />
                ) : (
                  'Go!'
                )}
              </>
            )}
          </SubmitButton>
        </Form>
      </FormContainer>
    </BookingContainer>
  );
};

const BookingContainer = styled.section`
  grid-row: 2;
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  margin: 0 auto;
  width: clamp(15.5rem, 50%, 25rem);
`;

export default NewVisit;