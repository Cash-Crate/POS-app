import React, { useState, useEffect } from "react";

const LoginTable = () => {
  const [logins, setLogins] = useState([]);

  useEffect(() => {
    fetch("demo.json") 
      .then((response) => response.json())
      .then((data) => setLogins(data))
      .catch((error) => console.error("Error fetching data:", error));
  }, []);

  return (
    <div className="p-4">
      <h2 className="text-xl font-bold mb-4">User Login History</h2>
      <div className="overflow-x-auto">
        <table className="min-w-full border border-gray-300">
          <thead>
            <tr className="bg-gray-100">
              {[
                "Login ID",
                "User ID",
                "Logged In",
                "Logged Out",
                "IP Address",
                "Device",
                "Browser",
                "CPU",
                "Host",
                "Origin",
              ].map((header, index) => (
                <th key={index} className="border px-4 py-2 text-left">
                  {header}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {logins.map((login) => (
              <tr key={login.login_id} className="border hover:bg-gray-50">
                <td className="border px-4 py-2">{login.login_id}</td>
                <td className="border px-4 py-2">{login.user_id}</td>
                <td className="border px-4 py-2">{login.Login_at}</td>
                <td className="border px-4 py-2">{login.Logout_at || "—"}</td>
                <td className="border px-4 py-2">{login.Ip_Addr}</td>
                <td className="border px-4 py-2">{login.device_type}</td>
                <td className="border px-4 py-2">{login.browser}</td>
                <td className="border px-4 py-2">{login.cpu_arch}</td>
                <td className="border px-4 py-2">{login.Host}</td>
                <td className="border px-4 py-2">{login.Origin}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default LoginTable;
