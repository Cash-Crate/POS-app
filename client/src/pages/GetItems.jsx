import React from 'react'
import Navbar from '../components/Navbar'
import { useState, useEffect  } from 'react'

const Items = () => {
  const [items, setItems] = useState([])

  useEffect(() => {
    getItems()
  }, [])

  async function getItems() {
    try {
      const res = await fetch('http://localhost:3000/api/items')
      const data = await res.json()
      setItems(data)
    } catch (error) {
      console.error(error.message);
    }
  }

  return (
    <>
      <Navbar />
      {items.map((item, index) => (
        <div className="border-b-2 border-gray-500 grid grid-cols-5" key={index}>
          <p>{item.item_type_name}</p>
          <p>{item.item_name}</p>
          <p>{item.item_image}</p>
          <p>{item.price}</p>
          <p>{item.quantity}</p>
        </div>
      ))}
    </>
  )
}

export default Items
