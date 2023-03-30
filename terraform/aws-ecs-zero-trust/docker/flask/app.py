from flask import Flask
from flask_restful import Resource, Api

app = Flask(__name__)
api = Api(app)

class MyClass(Resource):
    def get(self):
        return {'Hello': 'This is an flask rest API deployed in ECS'}

api.add_resource(MyClass, '/hello')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
