import { useEffect, useState } from 'react';
import socketIOClient from "socket.io-client";
import { Card } from 'antd';
import "./App.css";

const { Meta } = Card;
const ENDPOINT = "http://localhost:5000";

function App() {
  const [data, setData] = useState([]);

  // Fetch initial data
  useEffect(() => {
    fetch(`${ENDPOINT}/data`)
      .then(response => response.json())
      .then(data => {
        // Sort the data so the newest is displayed first
        data.sort((a, b) => new Date(b['Date and Time']) - new Date(a['Date and Time']));
        setData(data);
      })
      .catch(error => {
        console.error("Error fetching data: ", error);
      });
  }, []);

  // Listen for new data
  useEffect(() => {
    const socket = socketIOClient(ENDPOINT);
    socket.on("new data", newData => {
      setData(prevData => [newData, ...prevData.sort((a, b) => new Date(b['Date and Time']) - new Date(a['Date and Time']))]); // Add new data to the beginning of the list
    });
    return () => socket.disconnect();
  }, []);

  // Render your data
  return (
    <div className="app">
      {data.map((item, index) => (
        <Card key={index} style={{ width: 300, marginTop: 16, backgroundColor: "#bbb", color: "#fff" }} loading={false}>
          <Meta
            title={item['Server Name']}
            description={
              <>
                <p><strong>IP Address:</strong> {item['IP Address']}</p>
                <p><strong>Linux Distribution:</strong> {item['Linux Distribution']}</p>
                <p><strong>CPU Model:</strong> {item['CPU Model']}</p>
                <p><strong>Architecture:</strong> {item['Architecture']}</p>
                <p><strong>Memory Size:</strong> {item['Memory Size']}</p>
                <p><strong>Hard Disk Space:</strong> {item['Hard Disk Space']}</p>
                <p><strong>Date and Time:</strong> {item['Date and Time']}</p>
              </>
            }
          />
        </Card>
      ))}
    </div>
  );
}

export default App;
