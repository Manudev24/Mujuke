import React from 'react';
import { useEffect } from 'react';
import MusicItem from './MusicItem';

function QueujeList({ list }) {

    return (
        <div>
            {
                list.map((element) => {
                    return (
                        <MusicItem
                            src={`/Media/Images/${element.musicId}.jpeg`}
                            name={element.nombre}
                            artist={element.artistas}
                            userInfo={element.userInfo}
                            userName={element.userName}
                            userImg={element.UserImg}
                        />
                    );
                })}
        </div>
    );

}
export default QueujeList;