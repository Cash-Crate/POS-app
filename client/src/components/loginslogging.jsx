import React, { useState, useEffect } from "react";

const LoginTable = () => {
  const [logins, setLogins] = useState([]);

  useEffect(() => {
    fetch("http://localhost:8000/api/logins/") 
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
                "Email",
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
                <td className="border px-4 py-2">{login.email}</td>
                <td className="border px-4 py-2">{login.login_at}</td>
                <td className="border px-4 py-2">{login.logout_at || "—"}</td>
                <td className="border px-4 py-2">{login.ip_address}</td>
                <td className="border px-4 py-2">{login.device_type}</td>
                <td className="border px-4 py-2">{login.browser}</td>
                <td className="border px-4 py-2">{login.cpu_arch}</td>
                <td className="border px-4 py-2">{login.host}</td>
                <td className="border px-4 py-2">{login.origin}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default LoginTable;
