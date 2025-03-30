const updateProduct = async (editItem, openEditModal) => {
    const response = await fetch(`http://localhost:8000/api/items/${editItem.item_id}`, {
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
    openEditModal(false);
    window.location.reload();
};

export default updateProduct;