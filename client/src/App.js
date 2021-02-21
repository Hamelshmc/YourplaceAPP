import React, { Suspense } from 'react';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import Theme from './theme/Theme';

const Home = React.lazy(() => import('./pages/home'));
const SingIn = React.lazy(() => import('./pages/singIn'));

function App() {
  return (
    <Suspense fallback>
      <Router>
        <Theme>
          <Route exact path="/" component={Home} />
          <Route exact path="/sign_in" component={SingIn} />
        </Theme>
      </Router>
    </Suspense>
  );
}

export default App;
