document.addEventListener("DOMContentLoaded", () => {
  fetchAttendanceData();
  fetchLast10TagEvents();
});

async function fetchAttendanceData() {
  try {
    const response = await fetch("http://192.168.1.37:3000/api/data");
    const data = await response.json();
    displayAttendanceData(data);
  } catch (error) {
    console.error("Error fetching attendance data:", error);
  }
}

function displayAttendanceData(data) {
  const tableBody = document.getElementById("attendanceData");
  tableBody.innerHTML = "";

  data.forEach(entry => {
    const row = document.createElement("tr");
    row.innerHTML = `
      <td>${entry.name}</td>
      <td>${entry.date}</td>
      <td>${entry.time}</td>
    `;
    tableBody.appendChild(row);
  });
}

async function fetchLast10TagEvents() {
  try {
    const response = await fetch("http://192.168.1.37:3000/api/last-10-tag-events");
    const data = await response.json();
    displayLast10TagEvents(data);
  } catch (error) {
    console.error("Error fetching last 10 tag events:", error);
  }
}

function displayLast10TagEvents(data) {
  const tagEventsList = document.getElementById("tagEventsList");
  tagEventsList.innerHTML = "";

  data.forEach(event => {
    const listItem = document.createElement("li");
    listItem.textContent = `Tag ID: ${event.tag_id}, Event Type: ${event.event_type}, Timestamp: ${event.timestamp}`;
    tagEventsList.appendChild(listItem);
  });
}
