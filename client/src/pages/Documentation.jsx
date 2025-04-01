import Sidebar from "../components/Sidebar";
const Documentation = () => {
    return (
        <main className="h-screen w-screen overflow-hidden">
            <div className="flex flex-row h-full w-screen">
                <Sidebar />
                <section className="w-full ">
                </section>
            </div>
        </main>
    );
};
export default Documentation;