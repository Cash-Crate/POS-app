import { Link } from 'react-router-dom';
import test from '../../public/test.jpg'
import Sidebar from '../components/Sidebar'
import search from '../../public/search.svg'
import { motion } from "motion/react"
import { useEffect, useState } from "react";

const ProductsTable = () => {
    const [items, setProducts] = useState([]);
    const prodAttr = {};
        
    useEffect(() => {
        fetch("http://localhost:8000/api/items/") 
        .then((response) => response.json())
        .then((data) => setProducts(data))
        .catch((error) => console.error("Error fetching data:", error));
    }, []);
    
    items.forEach((item) => {
        prodAttr[item.item_id] = []; 
        let i = 0;
        for (const [_, value] of Object.entries(item)) {
            if (i > 6) {
                prodAttr[item.item_id].push(value);
            }
            i++;
        }
    });
    return (
      <main className="h-screen w-screen overflow-hidden">
            <div className="flex flex-row h-full w-screen">
                <Sidebar />
                <section className='flex flex-col gap-10 w-full p-5 overflow-y-hidden'>
                    <header className='flex flex-col gap-5'>
                    <div className='flex justify-center'>
                        <div className='flex flex-row gap-2 btn-dark py-2.5 px-2.5 w-full md:w-[60%] rounded-3xl'>
                            <img src={search} alt="search-icon" className="aspect-square h-5"/>
                            <input id="search" className="btn-dark w-full outline-none" type="search" name="search-bar" placeholder="Search"></input>
                        </div>
                    </div>
                    <div className="scroll overflow-x-auto">
                        <ul className="flex gap-2.5 items-center">
                            <motion.li whileTap={{ scale: 0.95 }} className="btn-highlight py-2.5 rounded-lg w-40 flex-shrink-0">
                                <Link to="/products">
                                    <button className="w-full">All</button>
                                </Link>
                            </motion.li>
                            <motion.li whileTap={{ scale: 0.95 }} className="btn-dark py-2.5 rounded-lg w-40 flex-shrink-0">
                                <Link to="/products">
                                    <button className="w-full">Beverages</button>
                                </Link>
                            </motion.li>
                            <motion.li whileTap={{ scale: 0.95 }} className="btn-dark py-2.5 rounded-lg w-40 flex-shrink-0">
                                <Link to="/products">
                                    <button className="w-full">Books</button>
                                </Link>
                            </motion.li>
                            <motion.li whileTap={{ scale: 0.95 }} className="btn-dark py-2.5 rounded-lg w-40 flex-shrink-0">
                                <Link to="/products">
                                    <button className="w-full">Clothing</button>
                                </Link>
                            </motion.li>
                            <motion.li whileTap={{ scale: 0.95 }} className="btn-dark py-2.5 rounded-lg w-40 flex-shrink-0">
                                <Link to="/products">
                                    <button className="w-full">Electronics</button>
                                </Link>
                            </motion.li>
                            <motion.li whileTap={{ scale: 0.95 }} className="btn-dark py-2.5 rounded-lg w-40 flex-shrink-0">
                                <Link to="/products">
                                    <button className="w-full">Furniture</button>
                                </Link>
                            </motion.li>
                            <motion.li whileTap={{ scale: 0.95 }} className="btn-dark py-2.5 rounded-lg w-40 flex-shrink-0">
                                <Link to="/products">
                                    <button className="w-full">Toys</button>
                                </Link>
                            </motion.li>
                        </ul>
                    </div>
                    </header>
                    <div className='scroll flex overflow-x-auto'>
                        <table className="w-full border-separate border-spacing-0">
                            <thead className="-hidden">
                                <tr className="btn-dark text-center">
                                    {[
                                        "ID",
                                        "Name",
                                        "Description",
                                        "Image",
                                        "Price",
                                        "Quantity",
                                        "Type",
                                        "Attributes"
                                    ].map((header, index, arr) => (
                                        <th key={index} className={`border px-4 py-2 text-center 
                                            ${index === 0 ? 'rounded-tl-lg' : ''} 
                                            ${index === arr.length - 1 ? 'rounded-tr-lg' : ''}`}>
                                            {header}
                                        </th>
                                    ))}
                                </tr>
                            </thead>
                            <tbody className='space-y-20'>
                                {items.map((item) => (
                                    <tr key={item.item_id}>
                                        <td className="border px-4 py-2 text-center ">{item.item_id}</td>
                                        <td className="border px-4 py-2 text-center">{item.item_name}</td>
                                        <td className="border px-4 py-2 text-center">{item.item_desc}</td>
                                        <td className="border px-4 py-2 text-center">
                                            {/*{item.item_image} replace */}
                                            <img src={test} alt="" className='aspect-square object-cover w-20' />
                                        </td>
                                        <td className="border px-4 py-2 text-center">{item.price}</td>
                                        <td className="border px-4 py-2 text-center">{item.quantity}</td>
                                        <td className="border px-4 py-2 text-center">{item.item_type_name}</td>
                                        <td className="border px-4 py-2">{
                                        prodAttr[item.item_id]?.join(", ") || "None"
                                        }</td>
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
  
  export default ProductsTable;
  