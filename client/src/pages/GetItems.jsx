import { fetchWithAuth } from '../utils/authUtils'
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
      const res = await fetchWithAuth('https://api.cashcrate.shop/api/users')
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
          <p>{item.user_id}</p>
          <p>{item.first_name}</p>
          <p>{item.last_name}</p>
          <p>{item.email}</p>
        </div>
      ))}
    </>
  )
}

export default Items
