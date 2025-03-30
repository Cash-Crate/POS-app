import { useState, useEffect } from 'react';
import Navbar from '../components/Navbar';

function Test() {
  //const API_BASE_URL = "https://api.cashcrate.shop";
  const API_BASE_URL = "http://localhost:3000";

  const [users, setUsers] = useState([]);
  const [name, setName] = useState("");
  const [birthYear, setBirthYear] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [address, setAddress] = useState("");
  const [phoneNumber, setPhoneNumber] = useState("");
  const [role, setRole] = useState("employee");

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
    const userData = {
      user_name: name,
      user_email: email,
      user_pass: password,
      birthdate: birthYear,
      address: address,
      phone_num: phoneNumber,
      role: role
    };

    console.log(userData)

    try {
      const res = await fetch(`${API_BASE_URL}/api/users/create/`, {
        method: "POST",
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(userData)
      });

      const data = await res.json();
      setUsers(prev => [...prev, data]);
      return null
    } catch (error) {
      console.error("Error adding user:", error);
      return error
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
      <Navbar />
      <h1 className="text-5xl font-bold">Users Website</h1>

      <div className="flex flex-col items-center *:border-2 
        *:border-red-500 *:mb-1 *:p-1
        ">
        <input
          type="text"
          placeholder="Enter name"
          onChange={(e) => setName(e.target.value)}
        />
        <input
          type="text"
          placeholder="yyyy-mm-dd"
          onChange={(e) => setBirthYear(e.target.value)}
        />
        <input
          type="text"
          placeholder="johhdoe@example.com"
          onChange={(e) => setEmail(e.target.value)}
        />
        <input
          type="text"
          placeholder="password1234"
          onChange={(e) => setPassword(e.target.value)}
        />
        <input
          type="text"
          placeholder="123 Main St"
          onChange={(e) => setAddress(e.target.value)}
        />
        <input
          type="text"
          placeholder="09xxxxxxxxxx"
          onChange={(e) => setPhoneNumber(e.target.value)}
        />
        <select name=""
          id=""
          value={role}
          onChange={(e) => {
            setRole(e.target.value)
            console.log(e.target.value)
          }}>
          <option value="employee">Employee</option>
          <option value="admin">Admin</option>
        </select>

        {/*<button onClick={addUser}>Add user</button>*/}
        <button onClick={async () => {
          console.log(
            name,
            birthYear,
            email,
            password,
            address,
            phoneNumber,
            role
          );
          const err = await addUser();
          if (err !== null) {
            console.log(err)
            return
          }
          setName("");
          setBirthYear("");
          setEmail("");
          setPassword("");
          setAddress("");
          setPhoneNumber("");
          setRole("");
          //window.location.reload()
        }}>
          Add user
        </button>
      </div>

      {users.map((user, index) => (
        <div key={index}
          className="pb-4 *:border-b-2 *:w-64 *:pb-1">
          <p>
            Name: {user.user_name}
            <button className="text-gray-100 px-1 border-red-500 border-2
              bg-red-500 rounded-md ml-2"
              onClick={() => delUser(user.user_id, index)}>X</button>
          </p>
          <p>User ID: {user.user_id}</p>
          <p>Birth Year: {user.birthdate}</p>
          <p>Email: {user.user_email}</p>
          <p>Password: {user.user_pass}</p>
          <p>Address: {user.address}</p>
          <p>Phone Number: {user.phone_num}</p>
          <p>Role: {user.role}</p>
        </div>
      ))}
    </>
  );
}

export default Test;
