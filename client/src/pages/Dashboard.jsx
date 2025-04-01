import { fetchWithAuth } from '../utils/authUtils'
import { main } from "motion/react-client";
import { useState, useEffect } from "react";
import Sidebar from "../components/Sidebar";
import { Pie, PieChart } from "recharts"
import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
  } from "@/components/ui/card"
  import {
    ChartContainer,
    ChartTooltip,
    ChartTooltipContent,
    ChartLegend,
    ChartLegendContent
  } from "@/components/ui/chart"
import { Bar, BarChart, CartesianGrid, XAxis } from "recharts"

const barData = [
    { month: "January", desktop: 186 },
    { month: "February", desktop: 305 },
    { month: "March", desktop: 237 },
    { month: "April", desktop: 73 },
    { month: "May", desktop: 209 },
    { month: "June", desktop: 214 },
    { month: "July", desktop: 321 },
    { month: "August", desktop: 213 },
    { month: "September", desktop: 142 },
    { month: "October", desktop: 217 },
    { month: "November", desktop: 285 },
    { month: "December", desktop: 170 }
  ]
  const pieData = [
    { browser: "Electronics", visitors: 275, fill: "var(--color-chart-1)" },
    { browser: "Clothing", visitors: 200, fill: "var(--color-chart-2)" },
    { browser: "Books", visitors: 187, fill: "var(--color-chart-3)" },
    { browser: "Furniture", visitors: 173, fill: "var(--color-chart-4)" },
    { browser: "Toys", visitors: 90, fill: "var(--color-chart-5)" },
    { browser: "Beverages", visitors: 90, fill: "var(--color-chart-6)" },
  ]
  const barConfig = {
    desktop: {
      label: "Desktop",
      color: "(var(--chart-1))",
    },
  } 
  const pieConfig = {
    Electronics: {
      label: "Electronics",
      color: "(var(--chart-1))",
    },
    Clothing: {
      label: "Clothing",
      color: "(var(--chart-2))",
    },
    Books: {
      label: "Books",
      color: "(var(--chart-3))",
    },
    Furniture: {
      label: "Furniture",
      color: "(var(--chart-4))",
    },
    Toys: {
      label: "Toys",
      color: "(var(--chart-5))",
    },
    Beverages: {
        label: "Beverages",
        color: "(var(--chart-6))",
    },
  }
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
        <main className="h-screen w-screen ">
            <div className="flex flex-row h-screen w-screen overflow-hidden ">
                <Sidebar />
                <section className="bg-gray-200 w-full p-4 md:p-8 overflow-y-auto"> 
                    <div className='grid lg:grid-cols-2 gap-2.5 xl:h-full'>

                        <div className="dashboard p-2.5 md:p-5 justify-center gap-2 "> 
                            <h4 className="text-xl">
                            Today's Sales
                            </h4>
                            <h3>
                                9,000
                            </h3>
                        </div>
                        <div className="dashboard p-2.5 md:p-5 justify-center gap-2"> 
                            <h4 className="text-xl">
                                Total Sales
                            </h4>
                            <h3>
                                330,000
                            </h3>
                        </div>
                        <div className="dashboard p-5 justify-between">
                            <CardHeader>
                                <h4>User CPU</h4>
                            </CardHeader>
                            <div className="">
                                <ChartContainer config={pieConfig} >
                                    <PieChart className=''>
                                        <Pie data={pieData} dataKey="visitors"/>
                                        <ChartLegend content={<ChartLegendContent nameKey="browser" />}className="flex-wrap [&>*]:basis-1 [&>*]:justify-center"/>
                                    </PieChart>
                                </ChartContainer>
                            </div>
                        </div>
                        <div className="dashboard p-5 justify-between">
                            <CardHeader className="items-center pb-0">
                                <h4>Device/Platform</h4>
                            </CardHeader>
                            <div className="">
                                <ChartContainer config={pieConfig} >
                                    <PieChart>
                                        <Pie data={pieData} dataKey="visitors"/>
                                        <ChartLegend content={<ChartLegendContent nameKey="browser" />}className="flex-wrap [&>*]:basis-1/4 lg:[&>*]:basis-1 [&>*]:justify-center"/>
                                    </PieChart>
                                </ChartContainer>
                            </div>
                        </div>
                        <div className="dashboard p-2.5 md:p-5 gap-2 lg:col-span-2 xl:col-span-1">
                            <CardHeader>
                                <h4>Sales Overview</h4>
                                <CardDescription>January - June 2025</CardDescription>
                            </CardHeader>
                            <CardContent>
                                <ChartContainer config={barConfig}>
                                <BarChart accessibilityLayer data={barData}>
                                    <CartesianGrid vertical={true} />
                                    <XAxis
                                    dataKey="month"
                                    tickLine={false}
                                    tickMargin={10}
                                    axisLine={true}
                                    tickFormatter={(value) => value.slice(0, 3)}
                                    />
                                    <ChartTooltip
                                    cursor={false}
                                    content={<ChartTooltipContent hideLabel />}
                                    />
                                    <Bar dataKey="desktop" fill="var(--color-desktop)" radius={8} />
                                </BarChart>
                                </ChartContainer>
                            </CardContent>
                        </div>
                        <div className="dashboard p-2.5 md:p-5 gap-2 max-h-[250px] md:max-h-none lg:col-span-2 xl:col-span-1">
                            <h4>
                                Low Stock
                            </h4>
                            <div className="data grid h-full overflow-y-scroll">
                                <table className='border-1'>
                                    <thead>
                                        <tr className='sticky top-0 bg-gray-200'>
                                            <th className="py-1.5 px-1 text-lg text-left">Product</th>
                                            <th className="text-center">Stock</th>
                                        </tr>
                                    </thead>
                                    <tbody className="overflow-hidden">
                                        <tr><td >prd 1</td><td className="text-center">10</td></tr>
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
                    </div>
                </section>
            </div>
        </main>
    )
};

export default Dashboard;
