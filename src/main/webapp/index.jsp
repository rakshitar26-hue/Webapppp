<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Food Cart</title>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial,sans-serif;
}

body{
    background:#f4f4f4;
}

header{
    background:#e23744;
    color:white;
    padding:15px;
    display:flex;
    justify-content:space-between;
    align-items:center;
}

header h2{
    font-size:28px;
}

.cart{
    font-size:18px;
    font-weight:bold;
}

.banner{
    height:300px;
    background:url("https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1200&q=80") center/cover;
    display:flex;
    justify-content:center;
    align-items:center;
    color:white;
    font-size:40px;
    font-weight:bold;
}

.container{
    width:90%;
    margin:30px auto;
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(250px,1fr));
    gap:20px;
}

.card{
    background:white;
    border-radius:10px;
    overflow:hidden;
    box-shadow:0 3px 10px rgba(0,0,0,.2);
    text-align:center;
}

.card img{
    width:100%;
    height:180px;
    object-fit:cover;
}

.card h3{
    margin:10px;
}

.card p{
    color:#555;
    margin-bottom:10px;
}

button{
    background:#e23744;
    color:white;
    border:none;
    padding:10px 20px;
    margin:15px;
    cursor:pointer;
    border-radius:5px;
}

button:hover{
    background:#c41d2c;
}

footer{
    margin-top:30px;
    text-align:center;
    background:#222;
    color:white;
    padding:15px;
}
</style>

</head>

<body>

<header>
    <h2>🍔 Food Cart</h2>
    <div class="cart">Cart : <span id="count">0</span></div>
</header>

<div class="banner">
    Delicious Food Delivered Fast
</div>

<div class="container">

    <div class="card">
        <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=80">
        <h3>Burger</h3>
        <p>₹149</p>
        <button onclick="addCart()">Add to Cart</button>
    </div>

    <div class="card">
        <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=80">
        <h3>Pizza</h3>
        <p>₹299</p>
        <button onclick="addCart()">Add to Cart</button>
    </div>

    <div class="card">
        <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=600&q=80">
        <h3>Pasta</h3>
        <p>₹199</p>
        <button onclick="addCart()">Add to Cart</button>
    </div>

    <div class="card">
        <img src="https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80">
        <h3>Sandwich</h3>
        <p>₹129</p>
        <button onclick="addCart()">Add to Cart</button>
    </div>

</div>

<footer>
    © 2026 Food Cart | Fresh Food • Fast Delivery
</footer>

<script>
let cart=0;

function addCart(){
    cart++;
    document.getElementById("count").innerHTML=cart;
    alert("Item Added Successfully!");
}
</script>

</body>
</html>
