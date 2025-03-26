import logo from '../../public/CashCrateLogo.webp'
import { motion } from "framer-motion"

const Home = () => {
  return (
    <main className="h-screen flex flex-col">
      <header className="head flex items-center justify-end px-4 md:px-8 py-6"> 
        <ul class="flex gap-8 items-center">
          <li className="underline"><a href="/login">Login</a></li>
          <li><motion.button whileTap={{ scale: 0.95 }} className="btn-highlight w-30 py-2 rounded-2xl">Install Now</motion.button></li>
        </ul>
      </header>
      <section className="bg-gradient h-full flex flex-col items-center gap-8 px-4 md:px-8 pt-[10vh] md:pt-[15vh]">
        <img src={logo} alt="Cash Crate Logo" className="aspect-square"/>
        <h1 className="text-5xl font-bold text-center">Cash Crate POS</h1>
        <motion.button whileTap={{ scale: 0.95 }} className="btn-light w-30 py-2 rounded-2xl">Install Now</motion.button>
      </section>
    </main>
  );
};

export default Home;
