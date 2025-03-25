import Navbar from "../components/Navbar";
import LoginTable from "../components/loginslogging";

const Home = () => {
  return (
    <>
      <Navbar />
      <main>
        <header>

        </header>
        <div className="flex flex-col items-center">
          <h1 className="text-5xl font-bold">Welcome to CashCrate</h1>
          <p className="text-xl">
            CashCrate is a POS (Point of Sale) management system for small businesses.
          </p>
        </div>
      </main>
      <LoginTable />
    </>
  );
};

export default Home;
