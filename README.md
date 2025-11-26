# Построение модели классификации ирисов Фишера с помощью Spark ML
## Характеристики модели:
- **Алгоритм**: Logistic Regression
- **Точность**: ~0.97
- **Классы**: setosa, versicolor, virginica

## Использование:
```python
from pyspark.ml import PipelineModel

model = PipelineModel.load("iris_model")
predictions = model.transform(new_data)
