import React from 'react';

function MusicItem({ src, name, artist, userName, userImg }) {

    return <div className='rowMusic'>
        <div>
            <img className='imgMusicItemAlbum' src={src} alt='Caratarula de la cancion' />
        </div>
        <div className='divInfoMusic'>
            <h1 className='songTitle'>{name}</h1>
            <p className='songInfo'>{artist}</p>
            <div>
                <p className='songInfo userName'>Sugerido por: {userName}</p>
                <img className='userImg' src={userImg} alt='Imagen del usuario' />
            </div>
        </div>
    </div>

}
export default MusicItem;