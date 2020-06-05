import json

def read_data_json():
  path = '/home/andres/projects/renewable-energy/python/'

  read_file = open(path + 'data.json')
  data = json.load(read_file)

  read_file.close()

  return data


data = read_data_json()


class show_options():
  print('\n'
    '1- ABM de centrales y zonas de demandan\n'
    '2- Listar las 3 centrales eólicas que más producen ordenadas en forma ascendente por MW producido\n'
    '3- Mostrar la ciudad o zona que menos consume en Argentina\n'
    '4- Determinar la demanda total a partir de la latitud -35.705º\n'
    '5- Determinar la producción total de las centrales comprendidas en la zona dada por las siguientes coordenadas (lat, long) (-31°,60°) (-20°,60°)(-31°,70°)(-20°,70°)\n'
    '6- Listar en forma ascendente por nombre de central aquellas centrales que producen más de 15MW\n'
    '7- Listar todas las centrales solares en forma ascendente por nombre de provincia \n'
    )
  print(data)
  print()
  option = int(input('Select an option: '))
  print(option)
  return option


option = show_options()

def showPowerPlants():
  print()
  print("The last data:")
  print()
  for i in data["powerPlants"]:
    print(i["name"])
  print()

def back_to_menu():
  menu = input("press 'm' to back menu")

  if(menu == "m"):
    show_options()

  print('1-Add a central');
  print('2-Remove a central');
  print('3-Modific a central');
  option = int(input('Select an option: '))
  
def crud_centrals():
  showPowerPlants()
  print("Add a Central prower with attributs: ")
  newPlant = {}
  newPlant["name"] = input("Name: ")
  newPlant["provinz"] = input("Provinz: ")
  newPlant["coordinates"] = input("Coordinates: ")
  newPlant["generatedPower"] = input("Generated power: ")
  newPlant["plantType"] = input("Plant type: ")
  data["powerPlants"].append(newPlant)
  showPowerPlants()
  back_to_menu()

    
    
  def removeCentral():
    showPowerPlants()
    centralID = int(input('Which central do you want to remove? '))
    del data["powerPlants"][centralID]
    showPowerPlants()

  def modificCentral():
    print()  

  if option == 1:
    addCentral()
  
  if option == 2:
    removeCentral()

  if option == 1:
    modificCentral()


menu_switch = {
  "1": crud_centrals(),
  "2": 0,
  "3": 0,
  "4": 0,
  "5": 0,
  "6": 0,
  "7": 0
}