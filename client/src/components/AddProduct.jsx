const addProduct = async () => {
    const response = await fetch("http://localhost:3000/api/items/create",
        {method: "POST",headers:{"Content-Type": "application/json"},body: JSON.stringify(newItem)
    });
    const addedItem = await response.json();
    setProducts((prevItems) => [...prevItems, addedItem]);
    openAddModal(false);
    setNewItem({ item_name: "", item_desc: "", item_image: "", price: "", quantity: "", item_type: "" }); 
   
};
export default addProduct;
