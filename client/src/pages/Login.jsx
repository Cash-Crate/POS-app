import image from '/CashCrateLogo.webp'
import { useState } from "react"
import { motion } from "motion/react"

const Login = () => {
  const [isActive, setActive] = useState(true);

  return (
    <main className="h-screen flex flex-col">
      <section className="bg-gradient h-full flex items-center justify-center py-5 px-4 md:px-8 xl:px-12">
        <div className='card flex flex-col gap-5 md:gap-5 px-5 py-7.5 lg:max-w-[500px] xl:max-w-[520px]'>
          <div className='flex flex-col items-center gap-2.5 md:gap-5'>
            <div className='flex flex-row items-center gap-2.5 pb-2'>
              <img src={image} alt="Cash Crate Logo" className="aspect-square w-10 md:w-12.5 lg:w-32"/>
              <h2>Cash Crate POS</h2>
            </div>
            <hr/>
            <h4>Ready to go? <strong>Log in</strong>!</h4>
          </div>
          <form action="POST" className='flex flex-col gap-2.5'>
            <div className='flex flex-col gap-2'>
              <label htmlFor="Email">Username</label>
              <motion.input whileTap={{ scale: 0.95 }} type="text" placeholder="your@email.com" className="input p-2 border-2 rounded-lg" required/>
            </div>
            <div className='flex flex-col gap-2'>
              <label htmlFor="password">Password</label>
              <motion.input whileTap={{ scale: 0.95 }} type="password" placeholder="********" className="input p-2 border-2 rounded-lg" required/>
            </div>
          </form>
            <motion.button whileTap={{ scale: 0.95 }} className='btn-highlight rounded-lg w-full py-2.5 text-white'>Log In</motion.button>
        </div>
      </section>
    </main>
  );
};

export default Login;
