from basic_generators import *

def generate_donor():
    params = [0, generate_age(), generate_sex(),
              generate_bloodtype(), generate_rhfactor(), generate_city()]
    params[0] = generate_name(params[2])
    return params

def generate_recipient(clinics):
    params = [generate_fk(1, len(clinics)), 0, generate_age(), generate_sex(),
              generate_bloodtype(), generate_rhfactor(), generate_city(), generate_priority()]
    params[1] = generate_name(params[2])
    params[6] = clinics[params[0]-1][0]
    return params

def generate_clinic():
    params = [generate_city(), generate_address(), generate_phone()]
    return params

def generate_surgeon(clinics):
    params = [generate_fk(1, len(clinics)), 0, randint(
        30, 80), generate_sex(), 0, 0]
    params[1] = generate_name(params[3])
    params[4] = randint(0, params[2] - 30)
    params[5] = clinics[params[0]-1][0]
    return params

def generate_organ():
    ograns = ["kidneys", "heart", "pancreas",
              "marrow", "liver", "skin", "lung"]
    params = [generate_fk(1, 1000), generate_fk(1, 100), choice(ograns), generate_fk(1, 240)]
    return params

def generate_operation():
    params = [0,generate_fk(1,1000),generate_fk(1,200),generate_fk(1,100),0,randint(30,180),generate_date()]
    return params
    
