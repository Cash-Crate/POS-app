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

// Pie chart data
// const pieData = [
//     { browser: "Update", visitors: update, fill: "var(--color-chart-1)" },
//     { browser: "Delete", visitors: deleteCount, fill: "var(--color-chart-2)" },
//     { browser: "Create", visitors: create, fill: "var(--color-chart-3)" },
//     { browser: "Sold", visitors: sold, fill: "var(--color-chart-4)" },
// ];

  const barConfig = {
    desktop: {
      label: "Desktop",
      color: "(var(--chart-1))",
    },
  } 

const Dashboard = () => {
    const [data, setCrudGraph] = useState([]);  
    const [pieCpu, setPieCpu] = useState([]);
    const [pieBrowser, setPieBrowser] = useState([]);
    const [cpuConfig, setCpuConfig] = useState({});
    const [browserConfig, setBrowserConfig] = useState({});
    
    useEffect(() => {
        fetchWithAuth("https://api.cashcrate.shop/api/logins", {}) 
            .then((response) => response.json())
            .then((data) => {
                setCrudGraph(data);  
                const cpuData = countForChart(data, "cpu_arch");
                setPieCpu(cpuData);
                setCpuConfig(generatePieConfig(cpuData));
                const browserData = countForChart(data, "browser");
                setPieBrowser(browserData);
                setBrowserConfig(generatePieConfig(browserData));
            })
            .catch((error) => console.error("Error fetching graph data:", error));
    }, []); 
    
    function countForChart(data, key) {
        const counts = {};
        data.forEach((entry) => {
            const value = entry[key];
            counts[value] = (counts[value] || 0) + 1;
        });
        let sortedData = Object.entries(counts)
            .map(([label, count]) => ({ label, count }))
            .sort((a, b) => b.count - a.count);
        let top5 = sortedData.slice(0, 5);
        let others = sortedData.slice(5);
    
        if (others.length > 0) {
            let othersCount = others.reduce((sum, item) => sum + item.count, 0);
            top5.push({ label: "Others", count: othersCount });
        }
        return top5.map((item, index) => ({
            crud: item.label,
            visitors: item.count,
            fill: `var(--chart-${index + 1})`
        }));
    }
    
    function generatePieConfig(pieData) {
        const config = {};
        pieData.forEach((item, index) => {
            config[item.crud] = {
                label: item.crud,
                color: `var(--chart-${index + 1})`,
            };
        });
        return config;
    }

    return (
        <main className="h-screen w-screen ">
            <div className="flex flex-row h-screen w-screen overflow-hidden ">
                <Sidebar />
                <section className="bg-gray-200 w-full p-4 md:p-8 overflow-y-auto"> 
                    <div className='grid lg:grid-cols-2 gap-2.5'>
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
                                <h4>CPU</h4>
                            </CardHeader>
                            <div>
                                <ChartContainer config={cpuConfig}>
                                    <PieChart>
                                        <Pie data={pieCpu} dataKey="visitors" />
                                        <ChartLegend 
                                            content={<ChartLegendContent nameKey="crud" />}
                                            className="flex-wrap [&>*]:basis-1 [&>*]:justify-center"
                                        />
                                    </PieChart>
                                </ChartContainer>
                            </div>
                        </div>

                        <div className="dashboard p-5 justify-between">
                            <CardHeader className="items-center pb-0">
                                <h4>Device/Platform</h4>
                            </CardHeader>
                            <div>
                                <ChartContainer config={browserConfig}>
                                    <PieChart>
                                        <Pie data={pieBrowser} dataKey="visitors" />
                                        <ChartLegend 
                                            content={<ChartLegendContent nameKey="crud" />}
                                            className="flex-wrap [&>*]:basis-1/4 lg:[&>*]:basis-1 [&>*]:justify-center"
                                        />
                                    </PieChart>
                                </ChartContainer>
                            </div>
                        </div>
                        <div className="dashboard p-2.5 md:p-5 gap-2 lg:col-span-2 xl:col-span-1">
                            <CardHeader>
                                <h4>Sales Overview</h4>
                                <CardDescription>Work Under Progres</CardDescription>
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
                                        <tr><td>Work under Progress</td></tr>
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
