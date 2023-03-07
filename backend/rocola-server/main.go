package main

import (
	"context"
	"encoding/json"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/rs/cors"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type Music struct {
	ID              primitive.ObjectID `json:"_id,omitempty" bson:"_id,omitempty"`
	Nombre          string             `json:"nombre,omitempty" bson:"nombre,omitempty"`
	Artistas        string             `json:"artistas,omitempty" bson:"artistas,omitempty"`
	ColorPrimario   string             `json:"colorPrimario,omitempty" bson:"colorPrimario,omitempty"`
	ColorSecundario string             `json:"colorSecundario,omitempty" bson:"colorSecundario,omitempty"`
}

type Song struct {
	ID              primitive.ObjectID `json:"_id,omitempty" bson:"_id,omitempty"`
	MusicId         string             `json:"musicId,omitempty" bson:"musicId,omitempty"`
	Nombre          string             `json:"nombre,omitempty" bson:"nombre,omitempty"`
	Artistas        string             `json:"artistas,omitempty" bson:"artistas,omitempty"`
	ColorPrimario   string             `json:"colorPrimario,omitempty" bson:"colorPrimario,omitempty"`
	ColorSecundario string             `json:"colorSecundario,omitempty" bson:"colorSecundario,omitempty"`
	UserName        string             `json:"userName,omitempty" bson:"userName,omitempty"`
	UserImg         string             `json:"UserImg,omitempty" bson:"UserImg,omitempty"`
}

type Current struct {
	ID      primitive.ObjectID `json:"_id,omitempty" bson:"_id,omitempty"`
	MusicId string             `json:"musicId,omitempty" bson:"musicId,omitempty"`
	Nombre  string             `json:"nombre,omitempty" bson:"nombre,omitempty"`
	Artista string             `json:"artista,omitempty" bson:"artista,omitempty"`
}

var client *mongo.Client

func main() {

	clientOptions := options.Client().ApplyURI("mongodb://localhost:27017")
	client, _ = mongo.Connect(context.Background(), clientOptions)

	router := mux.NewRouter()

	router.HandleFunc("/songs", GetSongs).Methods("GET")
	router.HandleFunc("/allmusic", GetAllMusic).Methods("GET")
	router.HandleFunc("/songs/name/{nombre}", GetSongsByName).Methods("GET")
	router.HandleFunc("/songs", AddSong).Methods("POST")
	router.HandleFunc("/songs/{id}", DeleteSong).Methods("DELETE")
	router.HandleFunc("/current", GetCurrent).Methods("GET")
	router.HandleFunc("/current", AddCurrent).Methods("POST")
	router.HandleFunc("/current", DeleteCurrent).Methods("DELETE")

	router.PathPrefix("/recursos/").Handler(http.StripPrefix("/recursos/", http.FileServer(http.Dir("./recursos"))))

	// Crear una instancia de cors con políticas personalizadas
	c := cors.New(cors.Options{
		AllowedOrigins: []string{"*"},
		AllowedMethods: []string{"GET", "POST", "DELETE"},
	})

	handler := c.Handler(router)

	log.Fatal(http.ListenAndServe(":8000", handler))
	http.ListenAndServe("0.0.0.0:8080", router)
}

func GetAllMusic(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var musics []Music
	collection := client.Database("MujukeDB").Collection("musics")
	cur, err := collection.Find(context.Background(), bson.D{})
	if err != nil {
		log.Fatal(err)
	}
	defer cur.Close(context.Background())
	for cur.Next(context.Background()) {
		var music Music
		err := cur.Decode(&music)
		if err != nil {
			log.Fatal(err)
		}
		musics = append(musics, music)
	}
	if err := cur.Err(); err != nil {
		log.Fatal(err)
	}
	json.NewEncoder(w).Encode(musics)
}

func GetSongs(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var songs []Song
	collection := client.Database("MujukeDB").Collection("Queue")
	cur, err := collection.Find(context.Background(), bson.D{})
	if err != nil {
		log.Fatal(err)
	}
	defer cur.Close(context.Background())
	for cur.Next(context.Background()) {
		var song Song
		err := cur.Decode(&song)
		if err != nil {
			log.Fatal(err)
		}
		songs = append(songs, song)
	}
	if err := cur.Err(); err != nil {
		log.Fatal(err)
	}
	json.NewEncoder(w).Encode(songs)
}
func AddSong(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var song Song
	err := json.NewDecoder(r.Body).Decode(&song)
	if err != nil {
		log.Fatal(err)
	}

	if song.ColorPrimario == "" || song.ColorSecundario == "" {

		musicCollection := client.Database("MujukeDB").Collection("musics")
		var music Music

		musicID, err := primitive.ObjectIDFromHex(song.MusicId)
		if err != nil {
			log.Fatal(err)
		}

		err = musicCollection.FindOne(context.Background(), bson.M{"_id": musicID}).Decode(&music)
		if err != nil {
			log.Fatal(err)
		}

		song.ColorPrimario = music.ColorPrimario
		song.ColorSecundario = music.ColorSecundario
	}

	queueCollection := client.Database("MujukeDB").Collection("Queue")
	result, err := queueCollection.InsertOne(context.Background(), song)
	if err != nil {
		log.Fatal(err)
	}
	json.NewEncoder(w).Encode(result)
}

func DeleteSong(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "http://localhost:5173")

	w.Header().Set("Access-Control-Allow-Methods", "DELETE")
	w.Header().Set("Content-Type", "application/json")

	params := mux.Vars(r)
	id, _ := primitive.ObjectIDFromHex(params["id"])

	collection := client.Database("MujukeDB").Collection("Queue")
	result, err := collection.DeleteOne(context.Background(), bson.M{"_id": id})
	if err != nil {
		log.Fatal(err)
	}

	json.NewEncoder(w).Encode(result)
}
func GetSongsByName(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	nombre := mux.Vars(r)["nombre"]

	filter := bson.M{"nombre": primitive.Regex{Pattern: nombre, Options: "i"}}

	var songs []Song
	collection := client.Database("MujukeDB").Collection("musics")
	cur, err := collection.Find(context.Background(), filter)
	if err != nil {
		log.Fatal(err)
	}
	defer cur.Close(context.Background())
	for cur.Next(context.Background()) {
		var song Song
		err := cur.Decode(&song)
		if err != nil {
			log.Fatal(err)
		}
		songs = append(songs, song)
	}
	if err := cur.Err(); err != nil {
		log.Fatal(err)
	}
	json.NewEncoder(w).Encode(songs)
}

func GetCurrent(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var current Current
	collection := client.Database("MujukeDB").Collection("Current")
	cur := collection.FindOne(context.Background(), bson.D{})
	err := cur.Decode(&current)
	if err != nil {
		log.Fatal(err)
	}
	json.NewEncoder(w).Encode(current)
}

func AddCurrent(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var current Current
	err := json.NewDecoder(r.Body).Decode(&current)
	if err != nil {
		log.Fatal(err)
	}
	collection := client.Database("MujukeDB").Collection("Current")
	_, err = collection.DeleteMany(context.Background(), bson.D{})
	if err != nil {
		log.Fatal(err)
	}
	_, err = collection.InsertOne(context.Background(), current)
	if err != nil {
		log.Fatal(err)
	}
	json.NewEncoder(w).Encode(current)
}

func DeleteCurrent(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "http://localhost:5173")

	w.Header().Set("Access-Control-Allow-Methods", "DELETE")
	w.Header().Set("Content-Type", "application/json")

	collection := client.Database("MujukeDB").Collection("Current")
	_, err := collection.DeleteMany(context.Background(), bson.D{})
	if err != nil {
		log.Fatal(err)
	}
	json.NewEncoder(w).Encode("Current eliminado")
}
