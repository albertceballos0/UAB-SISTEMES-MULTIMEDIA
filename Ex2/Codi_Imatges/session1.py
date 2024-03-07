import metrikz
import cv2
from PIL import Image
import matplotlib.pyplot as plt
import numpy as np
import os

def comprimir(imagen, nuevonombre, calidad):
    img = Image.open(imagen)
    img.save(nuevonombre, quality = calidad)
    img1 = os.stat(imagen).st_size
    img2 = os.stat(nuevonombre).st_size
    ratio = img1 / img2
    source = cv2.imread(imagen)
    target = cv2.imread(nuevonombre)

    return metrikz.mse(source, target), ratio








mse = {}
ratios = {} 
for j in range(1, 9):
  mse["image" + str(j)] = []
  ratios["image" + str(j)] = []

  error, ratio = comprimir("image" + str(j) + ".png","image" + str(j) + ".jpg", 1 )
  mse["image" + str(j)].append(error)
  ratios["image" + str(j)].append(ratio)
  for i in range(10,101, 10):
    error, ratio = comprimir("image" + str(j) + ".png","image" + str(j) + ".jpg", i )
    mse["image" + str(j)].append(error)
    ratios["image" + str(j)].append(ratio)
mse
  


plt.figure(figsize=(10,6))
plt.title("Figura 1")
for i in mse.keys():
  plt.plot(np.arange(0,101, 10),mse[i], label=i)
plt.legend()
plt.show()

plt.figure(figsize=(10,6))
plt.title("Figura 2")
for i in ratios.keys():
  plt.plot(np.arange(0,101, 10),ratios[i], label=i)
plt.legend()
plt.show()






ratios = {}
nombres = ["../../Ex3/Imatges/Airplane/airplane.ppm", "../../Ex3/Imatges/Baboon/baboon.ppm", "../../Ex3/Imatges/Moon/moon.pgm", "../../Ex3/Imatges/Pepper/pepper.ppm"]
comprJLS = ["../../Ex3/Imatges/Airplane/airplane.jls","../../Ex3/Imatges/Baboon/baboon.jls", "../../Ex3/Imatges/Moon/moon.jls", "../../Ex3/Imatges/Pepper/pepper.jls" ]
comprJPG = ["../../Ex3/Imatges/Airplane/airplane.jpg","../../Ex3/Imatges/Baboon/baboon.jpg", "../../Ex3/Imatges/Moon/moon.jpg", "../../Ex3/Imatges/Pepper/pepper.jpg" ]

"""for i in range(len(nombres)):
  original = os.stat(nombres[i]).st_size
  comprimidaJLS = os.stat(comprJLS[i]).st_size
  ratioJLS = original / comprimidaJLS
  comprimidaJPG = os.stat(comprJPG[i]).st_size
  ratioJPG = original / comprimidaJPG
  print("NOMBRE ARCHIVO", nombres[i ])
  print(ratioJLS, ratioJPG)
"""
  
nombres = ["../../Ex3/Imatges/Airplane/airplane.ppm", "../../Ex3/Imatges/Baboon/baboon.ppm", "../../Ex3/Imatges/Moon/moon.pgm", "../../Ex3/Imatges/Pepper/pepper.ppm"]
comprJLS = ["../../Ex3/Imatges/Airplane/airplane.jls","../../Ex3/Imatges/Baboon/baboon.jls", "../../Ex3/Imatges/Moon/moon.jls", "../../Ex3/Imatges/Pepper/pepper.jls" ]
comprJPG = ["../../Ex3/Imatges/Airplane/airplane.jpg","../../Ex3/Imatges/Baboon/baboon.jpg", "../../Ex3/Imatges/Moon/moon.jpg", "../../Ex3/Imatges/Pepper/pepper.jpg" ]
comprJPG = ["../../Ex3/Imatges/Airplane/airplane_2.ppm","../../Ex3/Imatges/Baboon/baboon_2.ppm", "../../Ex3/Imatges/Moon/moon_2.ppm", "../../Ex3/Imatges/Pepper/pepper_2.ppm" ]
comprJPG = ["../../Ex3/Imatges/Airplane/airplane_2.jpg","../../Ex3/Imatges/Baboon/baboon_2.jpg", "../../Ex3/Imatges/Moon/moon_2.jpg", "../../Ex3/Imatges/Pepper/pepper_2.jpg" ]
comprJPG = ["../../Ex3/Imatges/Airplane/airplane_2.jls","../../Ex3/Imatges/Baboon/baboon_2.jls", "../../Ex3/Imatges/Moon/moon_jls", "../../Ex3/Imatges/Pepper/pepper_2.jls" ]

for i in range(len(nombres)):
  original = os.stat(nombres[i]).st_size
  comprimidaJLS = os.stat(comprJLS[i]).st_size
  ratioJLS = original / comprimidaJLS
  comprimidaJPG = os.stat(comprJPG[i]).st_size
  ratioJPG = original / comprimidaJPG
  print("NOMBRE ARCHIVO", nombres[i ])
  print(ratioJLS, ratioJPG)
