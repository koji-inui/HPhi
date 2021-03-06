.. highlight:: none

.. _Subsec:ssTE:

SS.dat
~~~~~~

| (実時間発展法でのみ出力)実時間発展法での各ステップ毎の計算結果を出力します。以下にファイル例を示します。

::

     # time, energy, phys_var, phys_doublon, phys_num, step_i
    0.0000000000000000  -6.0412438187293001 38.8635272290786489 ...
    0.0100000000000000  -5.9310482979751606 37.9593669819686923 ...
    0.0200000000000000  -5.8287182777288828 37.1390062697724801 ...
    0.0300000000000000  -5.7384311863736031 36.4282319427381651 ...
    0.0400000000000000  -5.6636677030535481 35.8466140292489897 ...
    0.0500000000000000  -5.6070659264425551 35.4081795274108799 ...
    0.0600000000000000  -5.5703150294725914 35.1222606981659666 ...
    0.0700000000000000  -5.5540895348193438 34.9942503380419154 ...
    0.0800000000000000  -5.5580244678717312 35.0260574979670665 ...
    0.0900000000000000  -5.5807312981978212 35.2161499389042660 ...
    0.1000000000000000  -5.6198544688797947 35.5591788356216298 ...
    ...

ファイル名
^^^^^^^^^^

-  SS.dat

ファイル形式
^^^^^^^^^^^^

1行目はヘッダで、2行目以降は以下のファイル形式で記載されます。

-  :math:`[`\ double01\ :math:`]` :math:`[`\ double02\ :math:`]`
   :math:`[`\ double03\ :math:`]` :math:`[`\ double04\ :math:`]`
   :math:`[`\ double05\ :math:`]` :math:`[`\ int01\ :math:`]`

パラメータ
^^^^^^^^^^

-  :math:`[`\ double01\ :math:`]`

   **形式 :** double型

   **説明 :** 時間\ :math:`t`\ 。

-  :math:`[`\ double02\ :math:`]`

   **形式 :** double型

   **説明 :** ハミルトニアンの期待値(エネルギー)\ :math:`\langle \mathcal{H} \rangle`\ 。

-  :math:`[`\ double03\ :math:`]`

   **形式 :** double型

   **説明 :**
   ハミルトニアンの2乗の期待値\ :math:`\langle \mathcal{H}^2 \rangle`\ 。

-  :math:`[`\ double04\ :math:`]`

   **形式 :** double型

   **説明 :** ダブロン
   :math:`\frac{1}{N_s} \sum_{i}\langle n_{i\uparrow}n_{i\downarrow}\rangle`
   (ただし :math:`N_s`\ はサイト数)。

-  :math:`[`\ double05\ :math:`]`

   **形式 :** double型

   **説明 :** 粒子数\ :math:`\langle \sum_i n_i \rangle`\ 。

-  :math:`[`\ int01\ :math:`]`

   **形式 :** int型

   **説明 :** タイムステップ数。


.. raw:: latex

   \newpage
