import React from 'react';
import Confetti from 'react-confetti';
import { QueryClient, QueryClientProvider } from 'react-query';
import { Redirect, Route, Switch } from 'react-router-dom';
import Footer from './components/Footer/Footer';
import Header from './components/Header/Header';
import { UserProvider } from './hooks/UserContext';
import Wrapper from './theme/Wrapper';

const Home = React.lazy(() => import('./pages/Home'));
const Join = React.lazy(() => import('./pages/Join'));
const Search = React.lazy(() => import('./pages/Search'));
const Messages = React.lazy(() => import('./pages/Messages'));
const Like = React.lazy(() => import('./pages/Like'));
const Notification = React.lazy(() => import('./pages/Notification'));
const Profile = React.lazy(() => import('./pages/Profile'));
const Publication = React.lazy(() => import('./pages/Publication'));

// Create a client
const queryClient = new QueryClient();

function App() {
  return (
    <UserProvider>
      <Confetti numberOfPieces={300} recycle={false} />
      <Wrapper>
        <Header />
        <QueryClientProvider client={queryClient}>
          <Switch>
            <Route path="/publication" component={Publication} />
            <Route path="/profile" component={Profile} />
            <Route path="/notification" component={Notification} />
            <Route path="/like" component={Like} />
            <Route path="/messages" component={Messages} />
            <Route path="/search" component={Search} />
            <Route path="/join" component={Join} />
            <Route path="/" exact component={Home} />
            <Redirect to="/" />
          </Switch>
        </QueryClientProvider>
        <Footer />
      </Wrapper>
    </UserProvider>
  );
}

export default App;
