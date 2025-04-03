import { Link } from "react-router-dom";
import logo from "/CashCrateLogo.webp";
import { motion } from "motion/react";

const Home = () => {
  return (
    <main className="h-screen flex flex-col">
      <header className="head flex items-center justify-end px-4 md:px-8 py-6">
        <ul className="flex gap-8 items-center">
          <li className="underline">
            <Link to="/login">Login</Link>
          </li>
          <li>
            <a
              href="https://drive.google.com/file/d/1fnFmt91eZ7bNka5xAZrlyi0UL9pYBZ9l/view"
              target="_blank"
            >
              <motion.button
                whileTap={{ scale: 0.95 }}
                className="btn-highlight w-30 py-2 rounded-2xl"
              >
                Install Now
              </motion.button>
            </a>
          </li>
        </ul>
      </header>
      <section className="bg-gradient h-full flex flex-col items-center gap-8 px-4 md:px-8 pt-[10vh] md:pt-[15vh]">
        <img src={logo} alt="Cash Crate Logo" className="aspect-square" />
        <h1 className="text-5xl font-bold text-center">Cash Crate POS</h1>
        <a
          href="https://drive.google.com/file/d/1fnFmt91eZ7bNka5xAZrlyi0UL9pYBZ9l/view"
          target="_blank"
        >
          <motion.button
            whileTap={{ scale: 0.95 }}
            className="btn-light w-30 py-2 rounded-2xl"
          >
            Install Now
          </motion.button>
        </a>
      </section>
    </main>
  );
};

export default Home;
