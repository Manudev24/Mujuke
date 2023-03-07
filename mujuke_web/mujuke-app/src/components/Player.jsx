import React from 'react';
import AudioPlayer from 'react-cl-audio-player';
import image from "/Media/Images/63fa6fc1c0222303ec7a9687.jpeg"
import '@fortawesome/fontawesome-free/js/all.js';

function Player() {

    const canciones = [
        {
            _id: {
                $oid: "63fa6fc1c0222303ec7a9687"
            },
            nombre: "La Canción",
            artistas: "J Balvin, Bad Bunny",
            colorPrimario: "#c8cec9",
            colorSecundario: "#3f4e40"
        },
        {
            _id: {
                $oid: "63fa6fc1c0222303ec7a9688"
            },
            nombre: "No Se va",
            artistas: "Morat",
            colorPrimario: "#b68472",
            colorSecundario: "#3d2d19"
        },
        {
            _id: {
                $oid: "63fa6fc1c0222303ec7a9689"
            },
            nombre: "Sunroof",
            artistas: "Nicky Youre, dazy",
            colorPrimario: "#6fa5db",
            colorSecundario: "#a27a64"
        }
    ]

    const songs = [
        {
            url: '/Media/Music/63fa6fc1c0222303ec7a9687.mp3',
            cover: '/Media/Images/63fa6fc1c0222303ec7a9687.jpeg',
            artist: {
                name: 'LA CANCIÓN',
                song: 'J Balvin, Bad Bunny'
            }
        },
        {
            url: '/Media/Music/63fa6fc1c0222303ec7a9688.mp3',
            cover: '/Media/Images/63fa6fc1c0222303ec7a9688.jpeg',
            artist: {
                name: 'No Se Va',
                song: 'Morat'
            }
        }
    ];

    return <div>
        <AudioPlayer
            songs={songs}
            autoplay={false}
        />
    </div>

}
export default Player;