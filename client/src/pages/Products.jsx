import { Link } from 'react-router-dom';
import { motion } from "motion/react";
import { useEffect, useState } from "react";
import { fetchWithAuth } from "../utils/authUtils";
import test from '../../public/test.jpg';
import Sidebar from '../components/Sidebar';
import search from '../../public/search.svg';
import add from '../../public/add.svg';
import del from '../../public/delete.svg';
import edit from '../../public/edit.svg';
// import addProduct from '../components/AddProduct.jsx';
// import updateProduct from '../components/EditProduct';

const ProductsTable = () => {
    const [items, setProducts] = useState([]);
    const [searchQuery, setSearchQuery] = useState("");
    const [selectedType, setSelectedType] = useState("All");
    const [addModal, openAddModal] = useState(false);
    const [addAttrModal, openAddAttrModal] = useState(false);
    const [editModal, openEditModal] = useState(false);
    const [editItem, setEditItem] = useState(null);
    const [deleteModal, openDeleteModal] = useState(false);
    const [deleteItemId, setDeleteItemId] = useState(null);

    const [newItem, setNewItem] = useState({
        item_name: "",
        description: "",
        item_image: "",
        price: 0,
        quantity: 0,
        item_type: ""
    });
    const [newAttr, setAttr] = useState({
        attr_value: null,
        attr_name: null
    });
    
    useEffect(() => {
        fetchWithAuth("https://api.cashcrate.shop/api/items", {})
        .then((response) => response.json())
        .then((data) => setProducts(data))
        .catch((error) => console.error("Error fetching data:", error));
    }, [items]);

    const prodAttr = {};
    items.forEach((item) => {
        prodAttr[item.item_id] = []; 
        if (item.attributes == null){
            prodAttr[item.item_id].push("None");
        }else{
            item.attributes.forEach((attr) => {
                const attrString = `${attr.attr_name}: ${attr.attr_value}`; 
                prodAttr[item.item_id].push(attrString);
            });
        }
    });

    const confirmDelete = (id) => {
        setDeleteItemId(id);
        openDeleteModal(true);
    };
    
    const addProduct = async () => {
        const response = await fetchWithAuth("https://api.cashcrate.shop/api/items/create", 
            {method: "POST",headers: { "Content-Type": "application/json" },
            body: JSON.stringify(newItem),});
        const addedItem = await response.json();
        addedItem.id = addedItem.message.replace(/\D/g, "");
        setProducts((prevItems) => [...prevItems, addedItem]);
        setNewItem({ item_name: "", item_desc: "", item_image: "", price: "", quantity: "", item_type: "" });
        addAttr(addedItem.id);
        openAddModal(false);
    };

    const addAttr = async (id) => {
        console.log(newAttr);
        const response = await fetchWithAuth(`https://api.cashcrate.shop/api/items/attrs/create/${id}`, 
            {method: "POST",headers: { "Content-Type": "application/json" },body: JSON.stringify(newAttr),});
            const addedAttr = await response.json();
        console.log("success");
        setProducts((prevItems) => [...prevItems, addedAttr]);
        setAttr({ attr_name: "", attr_value: ""});
    }; 
    
    const updateAttr = async (editItem) => {
        const response = await fetchWithAuth(`https://api.cashcrate.shop/api/items/attrs/${editItem.item_id}/${editItem.attributes?.[0]?.attr_name}`, {
            method: "PUT",headers: {"Content-Type": "application/json",},
            body: JSON.stringify({
                attr_value: editItem.attributes?.[0]?.attr_value,
            }),
        });
    };  
    
    const updateProduct = async (editItem, openEditModal) => {
        const response = await fetchWithAuth(`https://api.cashcrate.shop/api/items/${editItem.item_id}`, {
            method: "PUT",headers: {"Content-Type": "application/json",},
            body: JSON.stringify({
                item_name: editItem.item_name,
                item_desc: editItem.item_desc,
                item_image: editItem.item_image,
                price: editItem.price,
                quantity: editItem.quantity,
                item_type: editItem.item_type 
            }),
        });
        editItem.attributes == null ?addAttr(editItem.item_id): updateAttr(editItem);
        openEditModal(false);
    };
    const deleteItem = async () => {
        if (!deleteItemId) return;
        try {
            await fetchWithAuth(`https://api.cashcrate.shop/api/items/${deleteItemId}`, { method: "DELETE" });
            setProducts((prevItems) => prevItems.filter(item => item.item_id !== deleteItemId));
            openDeleteModal(false);
            setDeleteItemId(null);
        } catch (error) {
            console.error("Error deleting item:", error);
        }
    };
    
    const filteredItems = items.filter((item) => {
        const query = searchQuery.toLowerCase();
        const typeMatch = selectedType === "All" || item.item_type === selectedType;
        return typeMatch && (
            item.item_id?.toString().includes(query) ||
            item.item_name?.toLowerCase().includes(query) ||
            item.description?.toLowerCase().includes(query) ||
            item.item_type?.toLowerCase().includes(query)
        );
    });
    
    return (
    <main className="h-screen w-screen">
        <div className="flex flex-row h-full">
            <Sidebar />
            <section className='flex flex-col gap-10 w-full py-5 overflow-hidden'>
                <header className='flex flex-col gap-5'>
                    <div className='flex justify-center px-5'>
                        <div className='flex flex-row gap-2 btn-dark py-2.5 px-2.5 w-full md:w-[60%] rounded-3xl'>
                            <img src={search} id="search" alt="search-icon" className="aspect-square h-5"/>
                            <input className="btn-dark w-full outline-none" type="search" placeholder="Search" value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)}/>
                        </div>
                    </div>
                    <div className="flex items-center gap-2 xl:px-5">
                        <motion.button  whileTap={{ scale: 0.9 }} className=" xl:hidden w-5 rounded-lg" onMouseDown={() => {document.getElementById("categoryScroll").scrollLeft -= 100;}}>
                            ◀
                        </motion.button>

                        <div id="categoryScroll" className="w-full scroll overflow-x-auto">
                            <fieldset className="xl:grid xl:grid-cols-7 flex flex-row gap-1.5 md:gap-2.5 items-center">{["All", "Beverages", "Books", "Clothing", "Electronics", "Furniture", "Toys"].map((type) => (
                                    <motion.label key={type} whileHover={{ scale: 1.05 }} whileTap={{ scale: 0.95 }} className={`cursor-pointer px-4 py-2.5 rounded-lg md:w-35 xl:w-full text-center 
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
                <article className='mx-5 overflow-x-auto'>
                    <div className="grid w-full ">
                        <table>
                            <thead>
                            <tr className="btn-dark text-center">
                                <th className="btn-dark sticky left-0 px-4 py-2 text-center rounded-tl-lg">
                                    Item ID
                                </th>
                                {[
                                "Name",
                                "Description",
                                "Image",
                                "Price",
                                "Quantity",
                                "Type",
                                "Attributes",
                                <button className="btn-highlight w-[45px] p-1 rounded-md text-center" onClick={() => openAddModal(true)}>
                                    <img src={add} alt="add-icon" className="aspect-square h-5 w-full" />
                                </button>,
                                ].map((header, index, arr) => (
                                    <th key={index} className={`px-4 py-2 text-center
                                        ${index === arr.length - 1 ? "rounded-tr-lg" : ""}`}>
                                    {header}
                                </th>
                                ))}
                            </tr>
                            </thead>
                            <tbody className="overflow-hidden">
                            {filteredItems.map((item) => (
                                <tr key={item.item_id} id={item.item_type}>
                                    <td className="px-4 py-2 sticky left-0 bg-background">{item.item_id}</td>
                                    <td className="table-data text-center min-w-5 max-w-10">{item.item_name}</td>
                                    <td className="table-data text-center min-w-5 max-w-10">{item.description}</td>
                                    <td className="table-data text-center min-w-5 max-w-10">
                                        <img src={item.item_image} alt={item.item_name} className="aspect-square object-cover w-full" />
                                    </td>
                                    <td className="table-data">{item.price}</td>
                                    <td className="table-data">{item.quantity}</td>
                                    <td className="table-data">{item.item_type}</td>
                                    <td className="px-4 py-2 h-full max-w-[250px]">
                                        <p className="line-clamp-3 hover:line-clamp-none">{prodAttr[item.item_id]?.join(", ") || "None"}</p>
                                    </td>
                                    <td className="table-data">
                                        <div className="flex justify-center gap-2">
                                        <button className="btn-highlight rounded-md p-1.5" onClick={() => { setEditItem(item); openEditModal(true); }}>
                                            <img src={edit} alt="edit-icon" className="max-w-none w-[20px]" />
                                        </button>
                                        <button className="btn-danger rounded-md p-1.5" onClick={() => confirmDelete(item.item_id)}>
                                            <img src={del} alt="delete-icon" className="max-w-none w-[20px]" />
                                        </button>
                                        </div>
                                    </td>
                                </tr>
                            ))}
                            </tbody>
                        </table>
                    </div>
                </article>
            </section>
        </div>
        {/* Modals */}
        {addModal && (
            <div className="fixed inset-0 flex items-center justify-center bg-gray-500/50">
                <div className="bg-white p-6 rounded-lg w-[400px] text-center">
                    <h3>Add Item</h3>  
                    <div className="flex flex-col gap-3">
                        <input type="text" placeholder="Name" className="border p-2 rounded" value={newItem.item_name} onChange={(e) => setNewItem({ ...newItem, item_name: e.target.value })}/>
                        <input type="text" placeholder="Description" width="48" height="48" className="border p-2 rounded" value={newItem.description} onChange={(e) => setNewItem({ ...newItem, description: e.target.value })}/>
                        <input className="w-full text-md text-gray-900 border border-gray-300 cursor-pointer h-7.5 bg-gray-50 placeholder-gray-400" onChange={(e) => setNewItem({ ...newItem, item_image: URL.createObjectURL(e.target.files[0]) })} id="image" type="file" accept="image/*"/>
                        {newItem.item_image && (<img src={newItem.item_image} alt="image input" className="w-10 object-cover rounded-lg"/>)}
                        {/* <input type="image" placeholder="Image URL"  className="border p-2 rounded" value={newItem.item_image} onChange={(e) => setNewItem({ ...newItem, item_image: e.target.value })}/> */}
                        <input type="number" placeholder="Price" className="border p-2 rounded" value={newItem.price} onChange={(e) => setNewItem({ ...newItem, price: parseFloat(e.target.value) })}/>
                        <input type="number" placeholder="Quantity" className="border p-2 rounded" value={newItem.quantity} onChange={(e) => setNewItem({ ...newItem, quantity: parseInt(e.target.value) })}/>
                        <select id="type" name="type" className="border p-2 rounded"  onChange={(e) => setNewItem({ ...newItem, item_type: e.target.value })}>
                            <option value="">Select Type</option>
                            <option value="Electronics">Electronics</option>
                            <option value="Clothing">Clothing</option>
                            <option value="Books">Books</option>
                            <option value="Furniture">Furniture</option>
                            <option value="Toys">Toys</option>
                            <option value="Beverages">Beverages</option>
                        </select>
                            <input type="text" placeholder="Attribute Name" className="border p-2 rounded" value={newAttr.attr_name} onChange={(e) => setAttr({ ...newAttr, attr_name: e.target.value })}/>
                            <input type="text" placeholder="Attribute Value" className="border p-2 rounded" value={newAttr.attr_value} onChange={(e) => setAttr({ ...newAttr, attr_value: e.target.value })}/>
                    </div>
                    <div className="flex justify-end mt-4 gap-2">
                        <button className="btn-dark px-4 py-2 rounded" onClick={() => openAddModal(false)}>Cancel</button>
                        <button className="btn-highlight px-4 py-2 rounded" onClick={addProduct}>Add</button>
                    </div>
                </div>
            </div>
        )}{addAttrModal && (
            <div className="fixed inset-0 flex items-center justify-center bg-gray-500/50">
                <div className="bg-white p-6 rounded-lg w-[400px] text-center">
                    <h3>Add Attribute</h3>  
                    <div className="flex flex-col gap-0.5">
                        <input type="text" placeholder="Attribute Name" className="border p-2 rounded" value={newAttr.attr_name} onChange={(e) => setAttr({ ...newAttr, attr_name: e.target.value })}/>
                        <input type="text" placeholder="Attribute Value" className="border p-2 rounded" value={newAttr.attr_value} onChange={(e) => setAttr({ ...newAttr, attr_value: e.target.value })}/>
                    </div>
                    <div className="flex justify-end mt-4 gap-2">
                        <button className="btn-dark px-4 py-2 rounded" onClick={() => openAddAttrModal(false)}>Cancel</button>
                        <button className="btn-highlight px-4 py-2 rounded" onClick={() => addAttr(id)}>Add</button>
                    </div>
                </div>
            </div>
        )}{editModal && editItem && (
            <div className="fixed inset-0 flex items-center justify-center bg-gray-500/50">
                <div className="bg-white p-6 rounded-lg w-[400px] text-center">
                    <h3>Edit</h3>
                    <div className="flex flex-col gap-3">
                        <input type="text" placeholder="Name" className="border p-2 rounded" value={editItem.item_name} onChange={(e) => setEditItem({ ...editItem, item_name: e.target.value })}/>
                        <input type="text" placeholder="Description" className="border p-2 rounded" value={editItem.description} onChange={(e) => setEditItem({ ...editItem, description: e.target.value })}/>
                        <input type="text" placeholder="Image URL" className="border p-2 rounded" value={editItem.item_image} onChange={(e) => setEditItem({ ...editItem, item_image: e.target.value })}/>
                        <input type="number" placeholder="Price" className="border p-2 rounded" value={editItem.price} onChange={(e) => setEditItem({ ...editItem, price: parseFloat(e.target.value) })}/>
                        <input type="number" placeholder="Quantity" className="border p-2 rounded" value={editItem.quantity} onChange={(e) => setEditItem({ ...editItem, quantity: parseInt(e.target.value) })}/>
                        <select id="type" name="type" className="border p-2 rounded" value={editItem.item_type} onChange={(e) => setEditItem({ ...editItem, item_type: (e.target.value) })} required>
                            <option value="">Select Type</option>
                            <option value="Electronics">Electronics</option>
                            <option value="Clothing">Clothing</option>
                            <option value="Books">Books</option>
                            <option value="Furniture">Furniture</option>
                            <option value="Toys">Toys</option>
                            <option value="Beverages">Beverages</option>
                        </select>
                        <input type="text" placeholder="Attribute Name" className="border p-2 rounded" value={editItem?.attributes?.[0]?.attr_name || newAttr?.attr_name && undefined } 
                        onChange={(e) => editItem.attributes == null? setAttr({ ...newAttr, attr_name: e.target.value }) :setEditItem({ ...editItem, attributes: [{ attr_name: e.target.value, attr_value: editItem.attributes?.[0]?.attr_value}] })} />

                        <input type="text" placeholder="Attribute Value" className="border p-2 rounded" value={editItem.attributes?.[0]?.attr_value || newAttr?.attr_value && undefined} 
                        onChange={(e) => editItem.attributes == null? setAttr({ ...newAttr, attr_value: e.target.value }) :setEditItem({ ...editItem, attributes: [{ attr_name: editItem.attributes?.[0]?.attr_name, attr_value: e.target.value}] })} />

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
  
