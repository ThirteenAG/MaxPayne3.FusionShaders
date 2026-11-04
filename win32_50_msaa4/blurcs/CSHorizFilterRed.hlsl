cbuffer cb0 : register(b1)
{
	float4 g_f4SampleWeights[15] : packoffset(c0);
	float4 g_f4RTSize : packoffset(c15);
};

Texture2D InputTex : register(t0);
RWTexture2D<float4> Result : register(u0);

groupshared float4 g0[128];

struct CS_IN
{
	uint sv_groupindex : SV_GroupIndex;
	uint3 sv_groupid : SV_GroupID;
};

[numthreads(128, 1, 1)]
void main(CS_IN i)
{
	int2 t2 = (int2)(g_f4RTSize.xy - 1);
	uint t0 = i.sv_groupindex - 7;
	int t1 = 114 * i.sv_groupid.x + t0;
	float3 t3 = InputTex.Load(int3(clamp(t1, 0, t2.x), min(t2.y, (int)i.sv_groupid.y), 0)).xyw;
	g0[i.sv_groupindex].x = t3.x;
	g0[i.sv_groupindex].w = t3.z;
	GroupMemoryBarrierWithGroupSync();
	if (114 * i.sv_groupid.x + i.sv_groupindex - 7 < (uint)g_f4RTSize.z && i.sv_groupindex < 121 && i.sv_groupindex >= 7) {
		float t4 = g0[i.sv_groupindex + 7].x;
		uint2 t5 = i.sv_groupindex + uint2(4, 5);
		float t6 = g0[i.sv_groupindex + 7].w;
		float2 t7 = float2(g0[i.sv_groupindex + 6].x, g0[i.sv_groupindex + 6].w);
		uint t8 = i.sv_groupindex - 3;
		Result[int2(t1, i.sv_groupid.y)] = float4(g0[t0].x * g_f4SampleWeights[0].x + g0[i.sv_groupindex - 6].x * g_f4SampleWeights[1].x + g0[i.sv_groupindex - 5].x * g_f4SampleWeights[2].x + g0[i.sv_groupindex - 4].x * g_f4SampleWeights[3].x + g0[t8].x * g_f4SampleWeights[4].x + g0[i.sv_groupindex - 2].x * g_f4SampleWeights[5].x + g0[i.sv_groupindex - 1].x * g_f4SampleWeights[6].x + t3.x * g_f4SampleWeights[7].x + g0[i.sv_groupindex + 1].x * g_f4SampleWeights[8].x + g0[i.sv_groupindex + 2].x * g_f4SampleWeights[9].x + g0[i.sv_groupindex + 3].x * g_f4SampleWeights[10].x + g0[t5.x].x * g_f4SampleWeights[11].x + g0[t5.y].x * g_f4SampleWeights[12].x + t7.x * g_f4SampleWeights[13].x + t4 * g_f4SampleWeights[14].x, t3.xy, g0[t0].w * g_f4SampleWeights[0].x + g0[i.sv_groupindex - 6].w * g_f4SampleWeights[1].x + g0[i.sv_groupindex - 5].w * g_f4SampleWeights[2].x + g0[i.sv_groupindex - 4].w * g_f4SampleWeights[3].x + g0[t8].w * g_f4SampleWeights[4].x + g0[i.sv_groupindex - 2].w * g_f4SampleWeights[5].x + g0[i.sv_groupindex - 1].w * g_f4SampleWeights[6].x + t3.z * g_f4SampleWeights[7].x + g0[i.sv_groupindex + 1].w * g_f4SampleWeights[8].x + g0[i.sv_groupindex + 2].w * g_f4SampleWeights[9].x + g0[i.sv_groupindex + 3].w * g_f4SampleWeights[10].x + g0[t5.x].w * g_f4SampleWeights[11].x + g0[t5.y].w * g_f4SampleWeights[12].x + t7.y * g_f4SampleWeights[13].x + t6 * g_f4SampleWeights[14].x);
	}
}
