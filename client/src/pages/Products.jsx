import { Link } from 'react-router-dom';
import test from '../../public/test.jpg';
import Sidebar from '../components/Sidebar';
import search from '../../public/search.svg';
import add from '../../public/add.svg';
import del from '../../public/delete.svg';
import edit from '../../public/edit.svg';
import addProduct from '../components/AddProduct';
import updateProduct from '../components/EditProduct';
import { motion } from "motion/react";
import { useEffect, useState } from "react";

const ProductsTable = () => {
    const [items, setProducts] = useState([]);
    const [searchQuery, setSearchQuery] = useState("");
    const [selectedType, setSelectedType] = useState("All");
    const [addModal, openAddModal] = useState(false);
    const [editModal, openEditModal] = useState(false);
    const [editItem, setEditItem] = useState(null);
    const [deleteModal, openDeleteModal] = useState(false);
    const [deleteItemId, setDeleteItemId] = useState(null);

    const [newItem, setNewItem] = useState({
        item_name: "",
        item_desc: "",
        item_image: "",
        price: "",
        quantity: "",
        item_type: ""
    });
    
    useEffect(() => {
        fetch("http://localhost:8000/api/items/") 
        .then((response) => response.json())
        .then((data) => setProducts(data))
        .catch((error) => console.error("Error fetching data:", error));
    }, []);

    const prodAttr = {};
    items.forEach((item) => {
        prodAttr[item.item_id] = []; 
        let i = 0;
        for (const [_, value] of Object.entries(item)) {
            if (i > 6) {
                prodAttr[item.item_id].push(value);
            }i++;
        }
    });

    const confirmDelete = (id) => {
        setDeleteItemId(id);
        openDeleteModal(true);
    };
    
    const deleteItem = async () => {
        if (!deleteItemId) return;
        try {
            await fetch(`http://localhost:8000/api/items/${deleteItemId}`, { method: "DELETE" });
            setProducts((prevItems) => prevItems.filter(item => item.item_id !== deleteItemId));
            openDeleteModal(false);
            setDeleteItemId(null);
        } catch (error) {
            console.error("Error deleting item:", error);
        }
    };
    

    const filteredItems = items.filter((item) => {
        const query = searchQuery.toLowerCase();
        const typeMatch = selectedType === "All" || item.item_type_name === selectedType;

        return typeMatch && (
            item.item_name?.toLowerCase().includes(query) ||
            item.item_desc?.toLowerCase().includes(query) ||
            item.item_type_name?.toLowerCase().includes(query)
        );
    });
    
    return (
    <main className="h-screen w-screen overflow-hidden">
        <div className="flex flex-row h-full w-screen">
            <Sidebar />
            <section className='flex flex-col gap-10 w-full p-5 overflow-x-scroll'>
                <header className='flex flex-col gap-5'>
                    <div className='flex justify-center'>
                        <div className='flex flex-row gap-2 btn-dark py-2.5 px-2.5 w-full md:w-[60%] rounded-3xl'>
                            <img src={search} id="search" alt="search-icon" className="aspect-square h-5"/>
                            <input className="btn-dark w-full outline-none" type="search" placeholder="Search" value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)}/>
                        </div>
                    </div>
                    <div className="flex items-center gap-2">
                        <motion.button  whileTap={{ scale: 0.9 }} className=" xl:hidden py-2 rounded-lg" onMouseDown={() => {document.getElementById("categoryScroll").scrollLeft -= 100;}}>
                            ◀
                        </motion.button>

                        <div id="categoryScroll" className="scroll overflow-x-auto flex">
                            <fieldset className="flex gap-2.5 items-center">{["All", "Beverages", "Books", "Clothing", "Electronics", "Furniture", "Toys"].map((type) => (
                                    <motion.label key={type} whileHover={{ scale: 1.05 }} whileTap={{ scale: 0.95 }} className={`cursor-pointer px-4 py-2 rounded-lg w-40 flex-shrink-0 text-center 
                                        ${selectedType === type ? "btn-highlight" : "btn-dark"}`}>
                                        <input type="radio" name="itemType" value={type} checked={selectedType === type} onChange={() => setSelectedType(type)} className="hidden"/>
                                        {type}
                                    </motion.label>
                                ))}
                            </fieldset>
                        </div>

                        <motion.button whileTap={{ scale: 0.9 }} className="xl:hidden py-2 rounded-lg" onMouseDown={() => {document.getElementById("categoryScroll").scrollLeft += 100;}}>
                            ▶
                        </motion.button>
                    </div>
                </header>
                <div className='flex overflow-x-auto'>
                    <table className="w-full border-separate border-spacing-0">
                        <thead className="-hidden">
                            <tr className="btn-dark text-center">
                                {["ID", "Name", "Description", "Image", "Price", "Quantity", "Type", "Attributes",
                                    <button className='btn-highlight w-[45px] p-1 rounded-md text-center' onClick={() => openAddModal(true)}>
                                        <img src={add} alt="add-icon" className="aspect-square h-5 w-full"/>
                                    </button>, 
                                ].map((header, index, arr) => (
                                    <th key={index} className={`border px-4 py-2 text-center 
                                        ${index === 0 ? 'rounded-tl-lg' : ''} 
                                        ${index === arr.length - 1 ? 'rounded-tr-lg' : ''}`}>
                                        {header}
                                    </th>
                                ))}
                            </tr>
                        </thead>
                        <tbody>
                            {filteredItems.map((item) => (
                                <tr key={item.item_id} id={item.item_type_name}>
                                    <td className="border px-4 py-2 text-center ">{item.item_id}</td>
                                    <td className="border px-4 py-2 text-center">{item.item_name}</td>
                                    <td className="border px-4 py-2 text-center">{item.item_desc}</td>
                                    <td className="border px-4 py-2 text-center">
                                        <img src={item.item_image} alt={item.item_name} className='aspect-square object-cover w-20' />
                                    </td>
                                    <td className="border px-4 py-2 text-center">{item.price}</td>
                                    <td className="border px-4 py-2 text-center">{item.quantity}</td>
                                    <td className="border px-4 py-2 text-center">{item.item_type_name}</td>
                                    <td className="border px-4 py-2">{prodAttr[item.item_id]?.join(", ") || "None"}</td>
                                    <td className="border px-4 py-2"> 
                                        <div className='flex justify-center gap-2'>
                                            <button className='btn-highlight rounded-md p-1.5' onClick={() => { setEditItem(item); openEditModal(true); }}>
                                                <img src={edit} alt="edit-icon" className="max-w-none w-[20px]" />
                                            </button>
                                            <button className='btn-danger rounded-md p-1.5' onClick={() => confirmDelete(item.item_id)}>
                                                <img src={del} alt="delete-icon" className="max-w-none w-[20px]" />
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
        {/* Modals */}
        {addModal && (
            <div className="fixed inset-0 flex items-center justify-center bg-gray-500/50">
                <div className="bg-white p-6 rounded-lg w-[400px] text-center">
                    <h3>Add</h3>  
                    <div className="flex flex-col gap-3">
                        <input type="text" placeholder="Name" className="border p-2 rounded" value={newItem.item_name} onChange={(e) => setNewItem({ ...newItem, item_name: e.target.value })}/>
                        <input type="text" placeholder="Description" className="border p-2 rounded" value={newItem.item_desc} onChange={(e) => setNewItem({ ...newItem, item_desc: e.target.value })}/>
                        <input type="text" placeholder="Image URL"  className="border p-2 rounded" value={newItem.item_image} onChange={(e) => setNewItem({ ...newItem, item_image: e.target.value })}/>
                        <input type="number" placeholder="Price" className="border p-2 rounded" value={newItem.price} onChange={(e) => setNewItem({ ...newItem, price: e.target.value })}/>
                        <input type="number" placeholder="Quantity" className="border p-2 rounded" value={newItem.quantity} onChange={(e) => setNewItem({ ...newItem, quantity: e.target.value })}/>
                        <select id="type" name="type" className="border p-2 rounded" onChange={(e) => setNewItem({ ...newItem, item_type: e.target.value })}>
                            <option value="1">Electronics</option>
                            <option value="2">Clothing</option>
                            <option value="3">Books</option>
                            <option value="4">Furniture</option>
                            <option value="5">Toys</option>
                            <option value="6">Beverages</option>
                        </select>
                    </div>
                    <div className="flex justify-end mt-4 gap-2">
                        <button className="btn-dark px-4 py-2 rounded" onClick={() => openAddModal(false)}>Cancel</button>
                        <button className="btn-highlight px-4 py-2 rounded" onClick={addProduct}>Add</button>
                    </div>
                </div>
            </div>
        )}{editModal && editItem && (
            <div className="fixed inset-0 flex items-center justify-center bg-gray-500/50">
                <div className="bg-white p-6 rounded-lg w-[400px] text-center">
                    <h3>Edit</h3>
                    <div className="flex flex-col gap-3">
                        <input type="text" placeholder="Name" className="border p-2 rounded" value={editItem.item_name} onChange={(e) => setEditItem({ ...editItem, item_name: e.target.value })}/>
                        <input type="text" placeholder="Description" className="border p-2 rounded" value={editItem.item_desc} onChange={(e) => setEditItem({ ...editItem, item_desc: e.target.value })}/>
                        <input type="text" placeholder="Image URL" className="border p-2 rounded" value={editItem.item_image} onChange={(e) => setEditItem({ ...editItem, item_image: e.target.value })}/>
                        <input type="number" placeholder="Price" className="border p-2 rounded" value={editItem.price} onChange={(e) => setEditItem({ ...editItem, price: parseFloat(e.target.value) })}/>
                        <input type="number" placeholder="Quantity" className="border p-2 rounded" value={editItem.quantity} onChange={(e) => setEditItem({ ...editItem, quantity: parseInt(e.target.value) })}/>

                        <select id="type" name="type" className="border p-2 rounded" placeholder="" value={editItem.item_type || ""} onChange={(e) => setEditItem({ ...editItem, item_type: parseInt(e.target.value) })} required>
                        <option value="">Select Type</option>
                        <option value="1">Electronics</option>
                        <option value="2">Clothing</option>
                        <option value="3">Books</option>
                        <option value="4">Furniture</option>
                        <option value="5">Toys</option>
                        <option value="6">Beverages</option>
                    </select>
                    </div>
                    <div className="flex justify-end mt-4 gap-2">
                        <button className="btn-dark px-4 py-2 rounded" onClick={() => openEditModal(false)}>Cancel</button>
                        <button className="btn-highlight px-4 py-2 rounded" onClick={() => updateProduct(editItem, openEditModal)}>Save</button>
                    </div>
                </div>
            </div>
        )}{deleteModal && (
            <div className="fixed inset-0 flex items-center justify-center bg-gray-500/50">
                <div className="bg-white p-6 rounded-lg w-[400px] text-center">
                    <h3 className="text-lg font-bold mb-4">Confirm Delete</h3>
                    <p>Are you sure you want to delete this item?</p>
                    <div className="flex justify-end mt-4 gap-2">
                        <button className="btn-dark px-4 py-2 rounded" onClick={() => openDeleteModal(false)}>Cancel</button>
                        <button className="btn-danger px-4 py-2 rounded" onClick={deleteItem}>Delete</button>
                    </div>
                </div>
            </div>
        )}
    </main>
    );
};

export default ProductsTable;
