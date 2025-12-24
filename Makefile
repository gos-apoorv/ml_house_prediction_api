# Variables
IMAGE_NAME=house_price_prediction_api
CONTAINER_NAME=house_price_prediction_api_container

.PHONY:

default: help

requirements-prod:
	pipenv requirements | sed -E '/^(--index-url|-i|--extra-index-url|--trusted-host)/d' > ./requirements	.txt

requirements-dev:
	pipenv requirements --dev | sed -E '/^(--index-url|-i|--extra-index-url|--trusted-host)/d' >> ./requirements.txt

requirements: requirements-prod requirements-dev ## Generate requirements.txt from pipenv

lint: ## lint with isort, black, flake8, mypy
	isort --profile black .; black .; flake8 .; mypy .;

docker-compose-up: ## Run the Docker Compose
	 docker compose up -d

docker-compose-down:: ## Stop the Docker Compose
	docker compose down

docker-build: ## Build the Docker image
	docker build -t $(IMAGE_NAME):latest .

docker-run: ## Run the Docker container
	docker run --name $(CONTAINER_NAME) -d -p 5001:5001 $(IMAGE_NAME):latest

docker-stop: ## Stop the running container
	docker stop $(CONTAINER_NAME)

docker-restart: docker-stop docker-run ## Restart the running container

docker-remove: ## Remove the container
	docker rm $(CONTAINER_NAME)

install-release: ## Deploy on K8s
	helm upgrade --install house-prediction-api ./helm-chart/house-prediction-api -f ./helm-chart/house-prediction-api/values.yaml -n house-prediction-ns --create-namespace

uninstall-release: ## Uninstall on K8s
	helm uninstall house-prediction-api -n house-prediction-ns

mlflow-ui: ## Run the MLFlow UI
	mlflow ui

train-run:  ## Run the train script
	python src/model_training.py

model-run:  ## Run the train script
	python src/model_training.py

app-run:  ## Run the app script
	python app.py

run-api:  ## Run the code
	curl -X POST http://127.0.0.1:5001/predict -H "Content-Type: application/json" -d '{"features": [8.3252, 41,  6.984,   1.023, 322,  2.555,   37.88, -122.23]}'

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
