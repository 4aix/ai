from flask import Flask, render_template
from predict import predict_apt_price, r_model
app = Flask(__name__)
@app.route('/')
def hello():
  return render_template('index.html') # templates/index.html
if __name__=='__main__':
  app.run(debug=True, port=8090)