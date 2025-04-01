import image from '/CashCrateLogo.webp'
import { useState } from "react"
import { motion } from "motion/react"
import { fetchWithAuth } from '../utils/authUtils';

const Login = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setIsLoading(true);

    try {
      const response = await fetch('https://api.cashcrate.shop/api/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          email,
          password
        }),
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || 'Login failed');
      }

      const data = await response.json();
      localStorage.setItem('accessToken', data.accessToken)
      localStorage.setItem('refreshToken', data.refreshToken)
      localStorage.setItem('userID', data.user_id)

      const expiresAt = new Date(new Date().getTime() + 15 * 60000).toISOString()
      localStorage.setItem('expiresAt', expiresAt)

      const user_id = localStorage.getItem('userID')
      await getUserID(user_id)

      window.location.href = '/dashboard';

    } catch (err) {
      setError(err.message || 'An error occurred during login');
      console.error('Login error:', err);
    } finally {
      setIsLoading(false);
    }
  };

  const getUserID = async (user_id) => {
    try {
      const res = await fetchWithAuth('https://api.cashcrate.shop/api/logins/create', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          user_id,
        })
      })
      const data = await res.json()
      localStorage.setItem('loginID', data.login_id)

    } catch (err) {
      console.error('Error getting user ID:', err);
    }
  }

  return (
    <main className="h-screen flex flex-col">
      <section className="bg-gradient h-full flex items-center justify-center py-5 px-4 md:px-8 xl:px-12">
        <div className='card flex flex-col gap-5 md:gap-5 px-5 py-7.5 lg:max-w-[500px] xl:max-w-[520px]'>
          <div className='flex flex-col items-center gap-2.5 md:gap-5'>
            <div className='flex flex-row items-center gap-2.5 pb-2'>
              <img src={image} alt="Cash Crate Logo" className="aspect-square w-10 md:w-12.5 lg:w-32" />
              <h2>Cash Crate POS</h2>
            </div>
            <hr />
            <h4>Ready to go? <strong>Log in</strong>!</h4>
          </div>

          {error && (
            <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative">
              {error}
            </div>
          )}

          <form className='flex flex-col gap-2.5' onSubmit={handleSubmit}>
            <div className='flex flex-col gap-2'>
              <label htmlFor="email">Email</label>
              <motion.input
                id="email"
                whileTap={{ scale: 0.95 }}
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                type="text"
                placeholder="your@email.com"
                className="input p-2 border-2 rounded-lg"
                required
              />
            </div>
            <div className='flex flex-col gap-2'>
              <label htmlFor="password">Password</label>
              <motion.input
                id="password"
                whileTap={{ scale: 0.95 }}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                type="password"
                placeholder="********"
                className="input p-2 border-2 rounded-lg"
                required
              />
            </div>
            <motion.button
              type="submit"
              whileTap={{ scale: 0.95 }}
              className='btn-highlight rounded-lg w-full py-2.5 text-white'
              disabled={isLoading}
            >
              {isLoading ? 'Logging in...' : 'Log In'}
            </motion.button>
          </form>
        </div>
      </section>
    </main>
  );
};
export default Login;
