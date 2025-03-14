import { useState, useEffect } from 'react';
import './App.css';

function App() {
  const API_BASE_URL = "https://api.cashcrate.shop"; // Updated API URL

  const [users, setUsers] = useState([]);
  const [name, setName] = useState("");
  const [birthYear, setBirthYear] = useState(0);

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      const res = await fetch(`${API_BASE_URL}/api/users/`);
      const data = await res.json();
      setUsers(data);
    } catch (error) {
      console.error("Error fetching users:", error);
    }
  };

  const addUser = async () => {
    const userData = { name, birth_year: birthYear };

    try {
      const res = await fetch(`${API_BASE_URL}/api/users/create/`, {
        method: "POST",
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(userData)
      });

      const data = await res.json();
      setUsers(prev => [...prev, data]);
    } catch (error) {
      console.error("Error adding user:", error);
    }
  };

  const delUser = async (id, index) => {
    try {
      await fetch(`${API_BASE_URL}/api/users/${id}/`, { method: "DELETE" });
      setUsers(prev => prev.filter((_, i) => i !== index));
    } catch (error) {
      console.error("Error deleting user:", error);
    }
  };

  return (
    <>
      <h1 className="text-5xl font-bold">Users Website</h1>

      <div>
        <input 
          type="text" 
          placeholder="Enter name" 
          onChange={(e) => setName(e.target.value)}
        />
        <input 
          type="number" 
          placeholder="Enter year" 
          onChange={(e) => setBirthYear(e.target.value)}
        />
        <button onClick={addUser}>Add user</button>
      </div>

      {users.map((user, index) => (
        <div key={index}>
          <p>
            Name: {user.name}
            <button onClick={() => delUser(user.id, index)}>X</button>
          </p>
          <p>Birth Year: {user.birth_year}</p>
        </div>
      ))}
    </>
  );
}

export default App;
