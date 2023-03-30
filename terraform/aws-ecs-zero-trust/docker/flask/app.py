from flask import Flask
from flask_restful import Resource, Api

app = Flask(__name__)
api = Api(app)

class WebApp(Resource):
    def get(self):
        return {'Hello': 'Flask deployed in ECS'}

api.add_resource(WebApp, '/hello')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
