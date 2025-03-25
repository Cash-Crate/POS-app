import { Link } from 'react-router-dom'

const Navbar = () => {
  return (
    <ul className="flex items-center justify-center space-x-8 text-red-500 
      mb-20 text-xl underline">
      <li><Link to="/">Home</Link></li>
      <li><Link to="/test">Test</Link></li>
      <li><Link to="/items">Items</Link></li>
    </ul>
  )
}

export default Navbar
