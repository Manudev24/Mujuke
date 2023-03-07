import { useState, useEffect } from 'react'
import QueujeList from './components/QueueList'
import React from 'react';
import '@fortawesome/fontawesome-free/js/all.js';
import axios from 'axios';
import MusicItem from './components/MusicItem';

function App() {

  const [primaryColor, setPrimaryColor] = useState("#9F9F9F");
  const [secondColor, setSecondColor] = useState("#373737");
  const [currentMusicId, setcurrentMusicId] = useState("loading");
  const [queueStatus, setQueueStatus] = useState("loading");
  const [currentMusicName, setCurrentMusicName] = useState("Cargando");
  const [currentMusicArtist, setCurrentMusicArtist] = useState("...");
  const [currentMusicIdQueue, setCurrentMusicIdQueue] = useState("");
  const [list, setList] = useState([]);

  let currentMusic = {
    queueId: "",
    musicId: "",
    name: "",
    artist: "",
    primaryColor: "",
    secondColor: ""
  }

  const postCurrent = async () => {
    try {
      const response = await axios.post('http://localhost:8000/current', {
        musicId: currentMusic.musicId,
        nombre: currentMusic.name,
        artista: currentMusic.artist
      });
      console.log(response.data);
    } catch (error) {
      console.error(error);
    }
  };

  const deleteCurrent = () => {
    axios.delete('http://localhost:8000/current')
      .then(response => {
        console.log(response.data);
      })
      .catch(error => {
        console.log(error);
      });
  }

  const updateCurrent = () => {
    axios.get('http://localhost:8000/current').then(
      response => {
        console.log(response.data);
        if (response.data == null) {
          postCurrent();
        } else {
          deleteCurrent();
        }
      }
    )
  }

  var array
  const loadCurrentMusic = () => {

    axios.get('http://localhost:8000/songs')
      .then(response => {
        let isRandom;
        if (response.data == null) {
          isRandom = true;
        } else {
          isRandom = false;
        }

        if (!isRandom) {
          array = response.data;
          currentMusic.queueId = response.data[0]._id;
          currentMusic.musicId = response.data[0].musicId;
          currentMusic.name = response.data[0].nombre;
          currentMusic.artist = response.data[0].artistas;
          currentMusic.primaryColor = response.data[0].colorPrimario;
          currentMusic.secondColor = response.data[0].colorSecundario;
          postCurrent();
          newMusic();
          axios.delete(`http://localhost:8000/songs/${currentMusic.queueId}`)
            .then(response => {

            })
            .catch(error => {
            });
        } else {
          loadRandomMusic();
        }

      })
      .catch(error => console.error(error))
  }

  const loadRandomMusic = () => {
    axios.get('http://localhost:8000/allmusic')
      .then(response => {
        let randomNumber = Math.floor((Math.random() * response.data.length))
        currentMusic.queueId = null;
        currentMusic.musicId = response.data[randomNumber]._id;
        currentMusic.name = response.data[randomNumber].nombre;
        currentMusic.artist = response.data[randomNumber].artistas;
        currentMusic.primaryColor = response.data[randomNumber].colorPrimario;
        currentMusic.secondColor = response.data[randomNumber].colorSecundario;
        postCurrent();
        newMusic();
      })
      .catch(error => console.error(error))
  }

  const newMusic = () => {
    setcurrentMusicId(currentMusic.musicId);
    setCurrentMusicName(currentMusic.name);
    setCurrentMusicArtist(currentMusic.artist);
    setPrimaryColor(currentMusic.primaryColor);
    setSecondColor(currentMusic.secondColor);
    setCurrentMusicIdQueue(currentMusic.queueId);


    if (currentMusic.queueId != null) {
      array.splice(0, 1);
    }
    setInterval(function () {
      axios.get('http://localhost:8000/songs')
        .then(response => {
          if (response.data != null) {
            setList(response.data);
          }

        })
        .catch(error => {
          console.log(error);
        });

    }, 5000);

  }

  const deleteMusic = () => {
    if (currentMusic.queueId != null) {
      axios.delete(`http://localhost:8000/songs/${currentMusicIdQueue}`)
        .then(response => {

        })
        .catch(error => {
        });
    }
    location.reload();
  }

  useEffect(() => {
    loadCurrentMusic();
  }, []);


  return (
    <div className="App" style={{ backgroundColor: secondColor }}>
      <div className="divMain" >
        <div className='groupOne' style={{ backgroundColor: primaryColor }} >
          <div className="divOne" style={{ backgroundColor: primaryColor }}>
            <h1 className="title">
              Reproduciendo</h1>
            <div >{
              currentMusicName === "Cargando" ? (
                <p>Cargando</p>
              ) : (
                <div className='divCurrentMusic'>
                  <img className='imgCurrentMusic' src={`http://localhost:8000/recursos/Media/Images/${currentMusicId}.jpeg`} />
                  <h1>{currentMusicName}</h1>
                  <p>{currentMusicArtist}</p>
                  <audio src={`http://localhost:8000/recursos/Media/Music/${currentMusicId}.mp3`} autoPlay controls onEnded={deleteMusic} /> </div>
              )
            }

            </div>
          </div>
          <div className="divTwo" style={{ backgroundColor: primaryColor }}>
            <h1 className="title">Siguientes</h1>

            <div >{
              queueStatus === "Cargando" ? (
                <p>Cargando</p>
              ) : (
                <QueujeList list={list} />
              )
            }
            </div>
          </div>
          <div className="divTwo" style={{ backgroundColor: primaryColor }}>
            <h1 className="title">Informaciones</h1>
            <p>Nos encanta proporcionar la banda sonora perfecta para cualquier ocasión, y queremos asegurarnos de que todos disfruten de su experiencia de escucha al máximo. Por favor, recuerde que nuestra aplicación está diseñada para proporcionar música adecuada para cualquier ambiente, por lo que le pedimos que sea consciente de la selección de canciones que elija.</p>
            <h1>Descargar</h1>
            <p>Escanea el siguiente codigo QR para obtener la aplicacion movil y poder agregar canciones a la cola.</p>
            <div className='divQr'>
              <img className='imgQr' src="/Media/QR_code.png" alt="Codigo QR" />
            </div>
          </div>
        </div>
        <div>
          <div></div>
          <div></div>
        </div>
      </div>
    </div>
  )
}

export default App
