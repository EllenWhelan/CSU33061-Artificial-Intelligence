#setup stuff  
# probability and reward matrices
PRMat = {
	'exercise': {
		'fit': {
			'fit': [0.9*0.99, 8],
			'unfit': [0.9*0.01, 8],
			'dead': [0.1, 0]
		},
		'unfit': {
			'fit': [0.9*0.2, 0],
			'unfit': [0.9*0.8, 0],
			'dead': [0.1, 0]
		},
		'dead': {
			'fit': [0, 0],
			'unfit': [0, 0],
			'dead': [1, 0]
		}
	},
	'relax': {
		'fit': {
			'fit': [0.99*0.7, 10],
			'unfit': [0.99*0.3, 10],
			'dead': [0.01, 0],
		},
		'unfit': {
			'fit': [0.99*0, 5],
			'unfit': [0.99*1, 5],
			'dead': [0.01, 0]
		},
		'dead': {
			'fit': [0, 0],
			'unfit': [0, 0],
			'dead': [1, 0]
		}
	}
}


#------------------------------------------------------------------
#functions
def q(n, s, a):
	if n == 0:
		return p(s, a, 'fit')*r(s, a, 'fit') +p(s, a, 'unfit')*r(s, a, 'unfit') +p(s, a, 'dead')*r(s, a, 'dead')
    else:
        return q(0, s, a) + (G*(p(s, a, 'fit')*v(n-1, 'fit') + p(s, a, 'unfit')*v(n-1, 'unfit') + p(s, a, 'dead')*v(n-1, 'dead')))

#prob of s->t, corner a
def p(s, a, t):
	return PRMat[a][s][t][0]

#reward s->t
def r(s, a, t):
	return PRMat[a][s][t][1]

def v(n, s):
	return max(q(n, s, 'exercise'), q(n, s, 'relax'))


        

#--------------------------------------------------------------------------
# testing- chnage these values to test code 
n=10
s='fit' #states = fit, unfit, dead
G=0.8

print("n=", n)
print("s=", s)
print("G=", G)
print("exercise=", q(n, s, 'exercise'))
print("relax=", q(n, s, 'relax'))

exit(0)