import { fetchWithAuth } from '../utils/authUtils'
import { main } from "motion/react-client";
import { useState, useEffect } from "react";
import Sidebar from "../components/Sidebar";

const Dashboard = () => {
    const [lowStock, setStocks] = useState([]);
    const [prodRank, setProdRank] = useState([]);
    const [graphData, setGraph] = useState([]);

    useEffect(() => {
        // fetchWithAuth("http://localhost:3000/api/ ", {})    api for low stocks
        //     .then((response) => response.json())
        //     .then((data) => setStocks(data))
        //     .catch((error) => console.error("Error fetching low stock data:", error));
    }, []);

    useEffect(() => {
        // fetchWithAuth("http://localhost:3000/api/ ", {})    api for product ranking
        //     .then((response) => response.json())
        //     .then((data) => setProdRank(data))
        //     .catch((error) => console.error("Error fetching product rank data:", error));
    }, []);

    useEffect(() => {
        // fetchWithAuth("http://localhost:3000/api/ ", {})    api for sales graph
        //     .then((response) => response.json())
        //     .then((data) => setGraph(data))
        //     .catch((error) => console.error("Error fetching graph data:", error));
    }, []);
    
    return (
        <main className="h-screen w-screen overflow-hidden">
            <div className="flex flex-row h-full w-screen">
            <Sidebar />
            <section className="bg-gray-200 w-full h-full grid grid-rows-10 sm:grid-cols-6  sm:grid-rows-6 xl:grid-rows-5 gap-2.5 md:gap-5 p-4 md:p-8 overflow-hidden">
                <div className="dashboard p-2.5 md:p-5 justify-center gap-2 sm:col-span-2"> 
                    <h4 className="">
                      Today's Sales
                    </h4>
                    <h3>
                        9,000
                    </h3>
                </div>

                <div className="dashboard p-2.5 md:p-5 justify-center gap-2 sm:col-span-2">
                    <h4 className="">
                        Previous Sales
                    </h4>
                    <h3>
                        10,000
                    </h3>
                </div>

                <div className="dashboard p-2.5 md:p-5 justify-center gap-2 sm:col-span-2">
                    <h4>
                        Total Sales
                    </h4>
                    <h3>
                        330,000
                    </h3>
                </div>
                
                <div className="dashboard p-2.5 md:p-5 gap-2 row-span-3 sm:col-span-6 xl:row-span-4 xl:col-span-4">
                    <h4>
                        Overview
                    </h4>
                </div>
                <div className="dashboard p-2.5 md:p-5 gap-2 row-span-2 sm:col-span-3 sm:row-span-2 xl:col-span-2">
                    <h4>
                        Products Ranking
                    </h4>
                </div>

                <div className="dashboard p-2.5 md:p-5 gap-2 row-span-2 sm:col-span-3 sm:row-span-2 xl:col-span-2">
                    <h4>
                        Low Stock
                    </h4>
                    <div className="relative data h-full ">
                        <table className="w-full grid">
                            <thead className="">
                                <tr>
                                    <th className="text-lg text-left">Product</th>
                                    <th className="text-center">Stock</th>
                                </tr>
                            </thead>
                            <tbody className="mt-2 overflow-y-scroll    ">
                                <tr><td>prd 1</td><td className="text-center">10</td></tr>
                                <tr><td>prd 1</td><td className="text-center">10</td></tr>
                                <tr><td>prd 1</td><td className="text-center">10</td></tr>
                                <tr><td>prd 1</td><td className="text-center">10</td></tr>
                                <tr><td>prd 1</td><td className="text-center">10</td></tr>
                                <tr><td>prd 1</td><td className="text-center">10</td></tr>
                                <tr><td>prd 1</td><td className="text-center">10</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>

            </section>
            </div>
        </main>
    )
};

export default Dashboard;
