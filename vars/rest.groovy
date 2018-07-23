import is.cinnamon.JenkinsHttpClient

def print_ghibli_films() {
    JenkinsHttpClient http = new JenkinsHttpClient()
    println(http.get('https://ghibliapi.herokuapp.com/films/'))
}
