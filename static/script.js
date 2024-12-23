document.getElementById('addProductForm').addEventListener('submit', async function (e) {
  e.preventDefault();
  const formData = new FormData(e.target);
  const data = Object.fromEntries(formData);

  try {
      const response = await fetch('/addProduct', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(data)
      });

      const result = await response.json();
      if (response.ok) {
          alert(result.message);
          e.target.reset();
      } else {
          alert('Error: ' + result.message);
      }
  } catch (error) {
      console.error('Error:', error);
      alert('An unexpected error occurred.');
  }
});
