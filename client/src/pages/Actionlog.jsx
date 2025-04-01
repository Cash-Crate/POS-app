import { fetchWithAuth } from '../utils/authUtils'
import { Link } from 'react-router-dom';
import Sidebar from '../components/Sidebar'
import search from '../../public/search.svg'
import { motion } from "motion/react"
import { useEffect, useState } from "react";

const ActionLogs = () => {
    const [actions, setCrud] = useState([]);
    const [searchQuery, setSearchQuery] = useState("");
    
      useEffect(() => {
        fetchWithAuth("http://localhost:3000/api/crud", {}) 
          .then((response) => response.json())
          .then((data) => setCrud(data))
          .catch((error) => console.error("Error fetching data:", error));
      }, []);

    const filteredItems = actions.filter((crud) => {
    const query = searchQuery.toLowerCase();
        return(
            crud.user_id.toString().includes(query) ||
            crud.action_taken?.toLowerCase().includes(query) ||
            crud.item?.toLowerCase().includes(query) 
        );
    });

    return (
      <main className="h-screen w-screen overflow-hidden">
            <div className="flex flex-row h-full w-screen">
                <Sidebar />
                <section className='flex flex-col gap-10 w-full p-5 overflow-y-hidden'>
                    <header className='flex flex-col gap-5'>
                        <div className='flex justify-center'>
                            <div className='flex flex-row gap-2 btn-dark py-2.5 px-2.5 w-full md:w-[60%] rounded-3xl'>
                                <img src={search} id="search" alt="search-icon" className="aspect-square h-5"/>
                                <input className="btn-dark w-full outline-none" type="search" placeholder="Search" value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)}/>
                            </div>
                        </div>
                        <div>    
                            <ul className='flex gap-2.5 items-center'>
                                <motion.li  whileTap={{ scale: 0.95 }} className='btn-dark w-full md:w-40 py-2.5 rounded-lg'>
                                    <Link to="/customerlog" className=''>
                                        <button className=' w-full'>Customer Logs</button>
                                    </Link>
                                </motion.li>
                                <motion.li  whileTap={{ scale: 0.95 }}  className='btn-highlight w-full md:w-40  py-2.5 rounded-lg'>
                                    <Link to="/actionlog" className=''>
                                        <button className='w-full'>Action Logs</button>
                                    </Link>
                                </motion.li>
                            </ul>
                        </div>
                    </header>
                    <div className='grid w-full overflow-auto'>
                        <table >
                            <thead >
                                <tr className="btn-dark text-center">
                                    <th className="table-data btn-dark sticky left-0 rounded-tl-lg z-10 whitespace-nowrap">
                                        User ID
                                    </th>
                                    {[
                                        "Date",
                                        "Operation",
                                        "Item",
                                    ].map((header, index, arr) => (
                                        <th key={index} className={`table-data whitespace-nowrap 
                                            ${index === arr.length - 1 ? 'rounded-tr-lg' : ''}`}>
                                            {header}
                                        </th>
                                    ))}
                                </tr>
                            </thead>
                            <tbody className='space-y-20'>
                                {filteredItems.map((crud) => (
                                    <tr key={crud.action_id}>
                                        <td className="table-data sticky left-0 bg-white">{crud.user_id}</td>
                                        <td className="table-data">{crud.action_at}</td>
                                        <td className="table-data">{crud.action_taken}</td>
                                        <td className="table-data">{crud.item}</td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </section>
            </div>
      </main>
    );
  };
  
  export default ActionLogs;
  
