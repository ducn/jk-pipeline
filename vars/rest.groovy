import is.cinnamon.JenkinsHttpClient

def print_ghibli_films() {
    JenkinsHttpClient http = new JenkinsHttpClient()
    dataset = readJSON text:http.get('http://176.32.82.108:5000/api/datasets/fetch?ids=t9iy')
    print(dataset)
}
