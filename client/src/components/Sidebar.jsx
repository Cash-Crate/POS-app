import { Link } from 'react-router-dom'
import image from '../../public/CashCrateLogo.webp'
import dashboard from '../../public/dashboard.svg'
import products from '../../public/products.svg'
import document from '../../public/document.svg'
import logs from '../../public/logs.svg'
import logout from '../../public/logout.svg'

const Sidebar = () => {
    return (
        <aside className='flex flex-col py-5 px-2.5 lg:px-5 border border-black justify-between'>{/* sidebar */}
                    <div className='flex flex-col gap-10'>
                        <img src={image} alt="Cash Crate Logo" className="aspect-square w-17.5 lg:w-full"/>
                        <ul className='hidden lg:flex flex-col gap-5 text-black'>
                            <li className='text-xl'><Link to="/dashboard">Dashboard</Link></li>
                            <li className='text-xl'><Link to="/products">Products</Link></li>
                            <li className='text-xl'><Link to="/documentation">Documentation</Link></li>
                            <li className='text-xl'><Link to="/customerlog">Logs</Link></li>
                        </ul>
                        <ul className='lg:hidden flex flex-col gap-5 text-black items-center'>
                            <li className='text-xl'>
                                <Link to="/dashboard"><img src={dashboard} alt="Dashboard Logo" className="aspect-square w-8"/></Link>
                            </li>
                            <li className='text-xl'>
                                <Link to="/products"><img src={products} alt="Products Logo" className="aspect-square w-8"/></Link>
                            </li>
                            <li className='text-xl'>
                                <Link to="/documentation"><img src={document} alt="Documentation Logo" className="aspect-square w-8"/></Link>
                            </li>
                            <li className='text-xl'>
                                <Link to="/customerlog"><img src={logs} alt="Logs Logo" className="aspect-square w-8"/></Link>
                            </li>
                        </ul>
                    </div>
                    <div className='self-center pb-5'>
                        <Link to="/" className='hidden lg:block text-xl underline'>Log out</Link>
                        <Link to="/" className='lg:hidden text-xl border border-none'>
                            <img src={logout} alt="Logout Icon" className="aspect-square w-8 border border-none"/>
                        </Link>
                    </div>
                </aside>
    );
};

export default Sidebar;