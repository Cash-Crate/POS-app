
import { fetchWithAuth } from "../utils/authUtils";
import { addAttr } from "@/pages/Products";
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

export default updateProduct;
