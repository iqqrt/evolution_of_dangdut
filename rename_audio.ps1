# Mapping dari nama lama ke nama baru
$audioMapping = @(
    @{old="Tan Sri P. Ramlee - Getaran Jiwa (Audio) - (64 Kbps).mp3"; new="001_getaran_jiwa.mp3"},
    @{old="OST Ibu Mertuaku 1962 - Jeritan Batinku - P Ramlee - (64 Kbps).mp3"; new="002_jeritan_batinku.mp3"},
    @{old="S.Effendy - Seroja ( 60an ) - (64 Kbps).mp3"; new="003_seroja.mp3"},
    @{old="Boneka Dari India (Almh. ELLYA KHADAM) Karya Almh. Ellya Khadam - (64 Kbps).mp3"; new="004_boneka_dari_india.mp3"},
    @{old="Rhoma Irama - Begadang (Lirik) - (64 Kbps).mp3"; new="005_begadang.mp3"},
    @{old="Rhoma Irama - Judi (Official Lyric Video) - (64 Kbps).mp3"; new="006_judi.mp3"},
    @{old="Rhoma Irama -  Darah Muda (Official Lyric Video) - (64 Kbps).mp3"; new="007_darah_muda.mp3"},
    @{old="ELVY SUKAESIH - SEKUNTUM MAWAR MERAH __ LAGU LAWAS __ TBMusic II - (64 Kbps).mp3"; new="008_sekuntum_mawar_merah.mp3"},
    @{old="Elvy Sukaesih - Gula Gula [offiicial] - (64 Kbps).mp3"; new="009_gula_gula.mp3"},
    @{old="Mansyur S - Air Tuba [Official Music Video] - (64 Kbps).mp3"; new="010_air_tuba.mp3"},
    @{old="Mansyur S - Rembulan Bersinar Lagi (Official Music Video) - (64 Kbps).mp3"; new="011_rembulan_bersinar_lagi.mp3"},
    @{old="Meggi Z - Benang Biru [Official Music Video] - (64 Kbps).mp3"; new="012_benang_biru.mp3"},
    @{old="Meggy Z -  Lebih Baik Sakit Gigi (Official Audio) - (64 Kbps).mp3"; new="013_lebih_baik_sakit_gigi.mp3"},
    @{old="A RAFIQ PANDANGAN PERTAMA 1   YouTube - (64 Kbps).mp3"; new="014_pandangan_pertama.mp3"},
    @{old="A.Rafiq ~ Pengalaman Pertama (hits 1978) 🕺🎶 video lyric - (64 Kbps).mp3"; new="015_pengalaman_pertama.mp3"},
    @{old="Camelia Malik - Colak Colek ( Official Lyric Video _ Hq stereo ) OST Colak Colek - (64 Kbps).mp3"; new="016_colak_colek.mp3"},
    @{old="dangdut - Iis dahlia - payung hitam - (64 Kbps).mp3"; new="017_payung_hitam.mp3"},
    @{old="Evie Tamala - Selamat Malam (Official Music Video) - (64 Kbps).mp3"; new="018_selamat_malam.mp3"},
    @{old="Ikke Nurjanah - Terlena (Official Music Video) - (64 Kbps).mp3"; new="019_terlena.mp3"},
    @{old="Inul Daratista - Goyang Inul (Official Music Video) - (64 Kbps).mp3"; new="020_goyang_inul.mp3"},
    @{old="dewi persik mimpi manis - (64 Kbps).mp3"; new="021_mimpi_manis.mp3"},
    @{old="Julia Perez - Belah Duren (Official Audio) - (64 Kbps).mp3"; new="022_belah_duren.mp3"},
    @{old="Putri Panggung (UUT PERMATASARI) Karya Jogi & H. Ukat S - (64 Kbps).mp3"; new="023_putri_panggung.mp3"},
    @{old="Via Vallen - Sayang (Official Music Video) - (64 Kbps).mp3"; new="024_sayang.mp3"},
    @{old="VIA VALLEN - MERAIH BINTANG - OFFICIAL THEME SONG ASIAN GAMES 2018 (Official Music Video) - (64 Kbps).mp3"; new="025_meraih_bintang.mp3"},
    @{old="Nella Kharisma - Jaran Goyang _ Dangdut [OFFICIAL MUSIC VIDEO] - (64 Kbps).mp3"; new="026_jaran_goyang.mp3"},
    @{old="Didi Kempot - Cidro _ Campursari   (Official Music Video) - (64 Kbps).mp3"; new="027_cidro.mp3"},
    @{old="Didi Kempot - Stasiun Balapan (Official Music Video) - (64 Kbps).mp3"; new="028_stasiun_balapan.mp3"},
    @{old="Denny Caknan - Kartonyono Medot Janji (Official Music Video) - (64 Kbps).mp3"; new="029_kartonyono_medot_janji.mp3"},
    @{old="HAPPY ASMARA - TAK IKHLASNO (Official Music Video) - (64 Kbps).mp3"; new="030_tak_ikhlasno.mp3"},
    @{old="Tenxi, Naykilla & Jemsii - Garam & Madu (Sakit Dadaku) (Official Music Video) - (64 Kbps).mp3"; new="031_garam_madu.mp3"}
)

$audioDir = "assets\audio"
$oldDir = "assets\audio\old_backup"

# Create backup folder
if (-not (Test-Path $oldDir)) {
    New-Item -ItemType Directory -Path $oldDir | Out-Null
    Write-Host "Created backup folder"
}

# Rename files
foreach ($map in $audioMapping) {
    $oldPath = Join-Path $audioDir $map.old
    $newPath = Join-Path $audioDir $map.new
    $backupPath = Join-Path $oldDir $map.old
    
    if (Test-Path $oldPath) {
        Copy-Item $oldPath -Destination $backupPath -Force | Out-Null
        Rename-Item $oldPath -NewName $map.new -Force
        Write-Host "Renamed: $($map.new)"
    } else {
        Write-Host "Not found: $($map.old)"
    }
}

Write-Host "Rename complete!"
