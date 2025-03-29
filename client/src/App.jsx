import {BrowserRouter as Router, Routes, Route} from 'react-router-dom';
import Home from './pages/Home';
import Test from './pages/test';
import Items from './pages/GetItems';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Documentation from './pages/Documentation';
import ProductsTable from './pages/Products';
import CustomerLogs from './pages/Customerlog';
import ActionLogs from './pages/Actionlog';
import './App.css';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/test" element={<Test />} />
        <Route path="/items" element={<Items />} />
        <Route path="/login" element={<Login />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path='/products' element={<ProductsTable/>} ></Route>
        <Route path="/customerlog" element={<CustomerLogs />} />
        <Route path="/actionlog" element={<ActionLogs />} />
        <Route path="/documentation" element={<Documentation />} />
      </Routes>
    </Router>
  );
}

export default App;
