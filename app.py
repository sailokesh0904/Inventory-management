from flask import Flask, render_template, request, redirect, url_for, flash
import mysql.connector

app = Flask(__name__)
app.secret_key = 'your_secret_key'


db_config = {
    'host': 'localhost',
    'user': 'enter your mysql username',
    'password': 'enter your mysql pswd',
    'database': 'inventory_management'
}


def connect_to_database():
    return mysql.connector.connect(**db_config)

@app.route('/')
def home():
    return render_template('home.html')


@app.route('/products', methods=['GET', 'POST'])
def products():
    conn = connect_to_database()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        product_name = request.form['product_name']
        category = request.form['category']
        price = request.form['price']
        stock_quantity = request.form['stock_quantity']
        suppliers = request.form['suppliers']

        try:
            cursor.execute("CALL AddProduct(%s, %s, %s, %s, %s)", 
                           (product_name, category, price, stock_quantity, suppliers))
            conn.commit()
            flash('Product added successfully!', 'success')
        except Exception as e:
            flash(f'Error adding product: {e}', 'danger')
    
    cursor.execute("SELECT * FROM Product")
    products = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('products.html', products=products)


@app.route('/customers', methods=['GET', 'POST'])
def customers():
    conn = connect_to_database()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        customer_id = request.form['customer_id']
        customer_name = request.form['customer_name']
        customer_address = request.form['customer_address']
        customer_phone = request.form['customer_phone']

        try:
            cursor.execute("CALL AddCustomer(%s, %s, %s, %s)", 
                           (customer_id, customer_name, customer_address, customer_phone))
            conn.commit()
            flash('Customer added successfully!', 'success')
        except Exception as e:
            flash(f'Error adding customer: {e}', 'danger')
    
    cursor.execute("SELECT * FROM Customer")
    customers = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('customers.html', customers=customers)


@app.route('/orders', methods=['GET', 'POST'])
def orders():
    conn = connect_to_database()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        customer_id = request.form['customer_id']
        order_date = request.form['order_date']
        total_amount = request.form['total_amount']

        try:
            cursor.execute("CALL ProcessOrder(%s, %s, %s)", 
                           (customer_id, order_date, total_amount))
            conn.commit()
            flash('Order added successfully!', 'success')
        except Exception as e:
            flash(f'Error adding order: {e}', 'danger')
    
    cursor.execute("SELECT * FROM Orders")
    orders = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('orders.html', orders=orders)

if __name__ == '__main__':
    app.run(debug=True)
