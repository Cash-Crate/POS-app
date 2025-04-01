import { Link } from 'react-router-dom'
import image from '../../public/CashCrateLogo.webp'
import dashboard from '../../public/dashboard.svg'
import products from '../../public/products.svg'
import document from '../../public/document.svg'
import logs from '../../public/logs.svg'
//import logout from '../../public/logout.svg'
import { fetchWithAuth } from '../utils/authUtils'
import { useState } from 'react'

const Sidebar = () => {
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState("");

    const handleLogout = async () => {
        setIsLoading(true);
        setError("")

        try {
            const refreshToken = localStorage.getItem('refreshToken')

            if (!refreshToken) {
                throw new Error('No refresh token available')
            }

            await fetchWithAuth(`https://api.cashcrate.shop/api/logins/${localStorage.getItem("loginID")}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                    }
                }
            )

            const res = await fetchWithAuth('https://api.cashcrate.shop/api/logout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ refreshToken: refreshToken })
            })

            if (!res.ok) {
                const errorData = await res.json()
                throw new Error(errorData.error || 'Logout failed')
            }

            localStorage.removeItem('accessToken')
            localStorage.removeItem('refreshToken')
            localStorage.removeItem('expiresAt')
            localStorage.removeItem('loginID')
            localStorage.removeItem('userID')

            window.location.href = '/login'
        } catch (err) {
            setError(err.message || 'An error occured during logout')
            console.error('Logout error: ', err)
        } finally {
            setIsLoading(false)
        }
    }

    return (
        <aside className='flex flex-col py-5 px-2.5 lg:px-5 border border-black justify-between'>{/* sidebar */}
            <div className='flex flex-col gap-10'>
                <img src={image} alt="Cash Crate Logo" className="aspect-square w-17.5 lg:w-full" />
                <ul className='hidden lg:flex flex-col gap-5 text-black'>
                    <li className='text-xl'><Link to="/dashboard">Dashboard</Link></li>
                    <li className='text-xl'><Link to="/products">Products</Link></li>
                    <li className='text-xl'><Link to="/documentation">Documentation</Link></li>
                    <li className='text-xl'><Link to="/customerlog">Logs</Link></li>
                </ul>
                <ul className='lg:hidden flex flex-col gap-5 text-black items-center'>
                    <li className='text-xl'>
                        <Link to="/dashboard"><img src={dashboard} alt="Dashboard Logo" className="aspect-square w-8" /></Link>
                    </li>
                    <li className='text-xl'>
                        <Link to="/products"><img src={products} alt="Products Logo" className="aspect-square w-8" /></Link>
                    </li>
                    <li className='text-xl'>
                        <Link to="/documentation"><img src={document} alt="Documentation Logo" className="aspect-square w-8" /></Link>
                    </li>
                    <li className='text-xl'>
                        <Link to="/customerlog"><img src={logs} alt="Logs Logo" className="aspect-square w-8" /></Link>
                    </li>
                </ul>
            </div>
            <div className='self-center pb-5'>
                {error && (
                    <div className="hidden lg:block text-xl underline">
                        {error}
                    </div>
                )}
                <button
                    className="text-xl underline"
                    onClick={handleLogout}
                    disabled={isLoading}
                >
                    {isLoading ? 'Logging out...' : 'Log out'}
                </button>

                {/*<Link to="/" className='hidden lg:block text-xl underline'>Log out</Link>*/}
                {/*<Link to="/" className='lg:hidden text-xl border border-none'>
                    <img src={logout} alt="Logout Icon" className="aspect-square w-8 border border-none" />
                </Link>*/}
            </div>
        </aside>
    );
};

export default Sidebar;
