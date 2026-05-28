const API_URL = "https://dkg5bcnx-8000.uks1.devtunnels.ms";

export const predict = async (datosPaciente) => {
  try {
    const response = await fetch(`${API_URL}/predictor`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(datosPaciente),
    });

    if (!response.ok) {
      throw new Error("Error en la respuesta del servidor médico");
    }

    return await response.json(); // Devuelve { prediccion: "Éxito/Fracaso", probabilidad: 0.XX }
  } catch (error) {
    console.error("Error al conectar con la API del Backend:", error);
    throw error;
  }
};